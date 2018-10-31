const jsonfile = require('jsonfile');

const { TOPO_FILE, COUNTRY_META, LOG_LEVEL } = process.env;

function saveUpdatedTopology(topoData, updatedGeometries) {
  const countries = topoData.objects.countries;

  topoData.objects.countries = {
    ...countries,
    geometries: updatedGeometries
  };

  jsonfile.writeFile(TOPO_FILE, topoData);
}

function summarizeTopo(properties) {
  return [
    properties.GEOUNIT,
    properties.GU_A3,
    properties.TYPE
    // properties.ISO_A2,
    // properties.ADM0_A3
  ].join(' | ');
}

function logCountryMatch(country, properties) {
  if (LOG_LEVEL !== 'DEBUG') return;

  const flag = country.flag || '🌐';
  const metaName = country.name;

  const matchString = `${flag}  ${summarizeTopo(properties)} => ${metaName}`;

  console.log('\x1b[2m%s\x1b[0m', matchString);
}

function logSummaryStats(
  topologies,
  updatedTopologies,
  countries,
  countriesMatched
) {
  if (LOG_LEVEL !== 'DEBUG') return;

  console.log('Number of topologies linked to geonames ids:');
  console.log(`${updatedTopologies.length} / ${topologies.length}`);
  console.log();
  console.log('Countries without topologies:');
  console.log(
    countries
      .filter(c => !countriesMatched.has(c))
      .map(c => `${c.flag}  ${c.name}`)
      .join('\n')
  );
}

function logMatchError({ properties }, error) {
  if (LOG_LEVEL !== 'DEBUG') return;

  const errorLine = `❔  ${summarizeTopo(properties)} - ${error}`;

  console.log('\x1b[1m%s\x1b[0m', errorLine);
}

const topoData = jsonfile.readFileSync(TOPO_FILE);
const countries = jsonfile.readFileSync(COUNTRY_META);

const countriesByA2 = new Map(countries.map(c => [c.iso, c]));
const countriesByA3 = new Map(countries.map(c => [c.iso_a3, c]));

// ⚠️ some of these are controversial editorial assignments ⚠️
// n.b. updated geonames + ISO data may resolve the need for them
const overrides = new Map([
  ['CYN', countries.find(c => c.iso === 'CY')], // Northern Cyprus => Cyprus
  ['GAZ', countries.find(c => c.iso === 'PS')], // Gaza => Palestine
  ['SOL', countries.find(c => c.iso === 'ET')], // Somaliland => Ethopia
  ['NLY', countries.find(c => c.iso === 'BQ')], // Carribbean NL => Bonaire...
  ['NLX', countries.find(c => c.iso === 'NL')], // Mainland NL => Netherlands
  ['NSV', countries.find(c => c.iso === 'SJ')], // Svalbard => Sv. & Jan Mayen
  ['WEB', countries.find(c => c.iso === 'PS')] //  West Bank => Palestine
]);

const topologies = [...topoData.objects.countries.geometries];
const updatedTopologies = [];
const countriesMatched = new Set();

topologies.sort((a, b) => {
  if (a.properties.GEOUNIT < b.properties.GEOUNIT) return -1;
  if (a.properties.GEOUNIT > b.properties.GEOUNIT) return +1;
  else {
    return 0;
  }
});

for (let topology of topologies) {
  let properties = topology.properties;
  let isoGeoUnit = properties.GU_A3;
  let error = undefined;

  // start by attempting to lookup the ISO code for the corresponding geounit
  let country = countriesByA3.get(isoGeoUnit) || overrides.get(isoGeoUnit);

  // if no match found, use tactics based on the territory type
  if (!country) {
    switch (properties.TYPE) {
      case 'Country':
      case 'Sovereign country':
        // fall back to ISO_A2 - some of the iso_A3 codes are inaccurate at source :(
        country = countriesByA2.get(properties.ISO_A2);

        if (!country)
          error = 'Unable to find geonames record for top-level country';

        break;

      case 'Geo unit':
      case 'Dependency':
        // fall back to ADM0_A3 - parent country code
        country = countriesByA3.get(properties.ADM0_A3);

        if (!country)
          error = 'Unable to find geonames record for parent country';

        break;

      case 'Indeterminate':
        // fall back to ISO_A2 - this covers Western Sahara which has an ISO code assigned
        country = countriesByA2.get(properties.ISO_A2);

        if (!country) error = 'Unsure how to proceed with this territory';

        break;
    }
  }

  if (country) {
    countriesMatched.add(country);

    updatedTopologies.push({
      ...topology,
      id: country.geonames_id,
      properties: {
        name: properties.GEOUNIT
      }
    });

    logCountryMatch(country, properties);
  } else {
    logMatchError(topology, error);
  }
}

// sumarize stats
logSummaryStats(topologies, updatedTopologies, countries, countriesMatched);

// update JSON file data
saveUpdatedTopology(topoData, updatedTopologies);
