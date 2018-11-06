const jsonfile = require('jsonfile');
const topoClient = require('topojson-client');
const topoServer = require('topojson-server');

const { TOPO_FILE, COUNTRY_META, LOG_LEVEL } = process.env;

const topology = jsonfile.readFileSync(TOPO_FILE);
const countries = jsonfile.readFileSync(COUNTRY_META);

const countriesByA3 = new Map(countries.map(c => [c.iso_a3, c]));
const countryTopologies = new Map(countries.map(c => [c, []]));

const adminRegions = topoClient.feature(
  topology,
  topology.objects.adminRegions
);

const { type, features: allFeatures } = adminRegions;

// for every country, finding any admin regions that belong to it and
// build a dedicated topology file named with the appropriate geonames id
Promise.all(
  countries.map(country => {
    const { iso_a3, geonames_id } = country;

    const filename = `topo/countries/${geonames_id}.json`;
    const belongsToCountry = f => f.properties.iso === iso_a3;

    const features = allFeatures.filter(belongsToCountry);
    const adminRegions = {
      type,
      features
    };

    const countryTopo = topoServer.topology({ adminRegions }, 1e5);

    if (LOG_LEVEL === 'DEBUG')
      console.log('writing', filename, iso_a3, features.length);

    return jsonfile.writeFile(filename, countryTopo);
  })
).then(items => console.log(items.length, 'country topologies written'));
