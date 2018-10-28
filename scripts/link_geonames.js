const fs = require('fs-extra'); // promisified fs impl

const DEFAULT_ENCODING = 'utf8';

const { TARGET_FILE } = process.env;

// load a JSON file from the local filesystem and return the relevant data object
function loadJSON(fileName) {
  return fs.readFile(fileName, DEFAULT_ENCODING).then(fileData => {
    return Promise.resolve(JSON.parse(fileData));
  });
}

// save a given data object to the local filesystem in JSON format
function saveJSON(fileName, data) {
  const json = JSON.stringify(data);
  const task = fs.writeFile(fileName, json, DEFAULT_ENCODING);

  return task;
}

function debugTopo({ properties }, error) {
  console.log(
    error,
    '-',
    [
      properties.GEOUNIT,
      properties.TYPE,
      properties.ISO_A2,
      properties.GU_A3,
      properties.ADM0_A3
    ].toString()
  );
}

loadJSON('meta/countries.json').then(countries => {
  const countriesByA2 = new Map(countries.map(c => [c.iso, c]));
  const countriesByA3 = new Map(countries.map(c => [c.iso_a3, c]));

  loadJSON(TARGET_FILE).then(data => {
    const topologies = [...data.objects.countries.geometries];
    const updatedTopologies = [];
    const countriesMatched = new Set();

    for (let topology of topologies) {
      let properties = topology.properties;
      let error = undefined;

      // start by attempting to lookup the ISO code for the corresponding geounit
      let country = countriesByA3.get(properties.GU_A3);

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
        console.log(properties.GEOUNIT, '=>', country.name, country.flag);

        countriesMatched.add(country);

        updatedTopologies.push({
          ...topology,
          id: country.geonames_id,
          properties: {
            name: properties.GEOUNIT
          }
        });
      } else {
        debugTopo(topology, error);
      }
    }

    // update JSON file data
    data.objects.countries.geometries = updatedTopologies;
    saveJSON(TARGET_FILE, data);

    console.log();
    console.log('Number of topologies linked to geonames ids:');
    console.log(`${updatedTopologies.length} / ${topologies.length}`);
    console.log();
    console.log('Number of countries matched to topologies:');
    console.log(`${countriesMatched.size} / ${countries.length}`);
    console.log();
    console.log('Countries without topologies:');
    console.log(
      countries
        .filter(c => !countriesMatched.has(c))
        .map(c => `${c.flag}  ${c.name}`)
        .join('\n')
    );
  });
});
