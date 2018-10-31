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

const { type, features } = adminRegions;

const [firstFeature] = features;

console.log(Object.keys(firstFeature.properties));

// return;

Promise.all(
  countries.map(country => {
    const { iso_a3, geonames_id } = country;

    const filename = `topo/countries/${geonames_id}.json`;
    const countryFeatures = features.filter(f => f.properties.gu_a3 === iso_a3);
    const countryGeo = {
      type,
      features: countryFeatures
    };

    const countryTopo = topoServer.topology(countryGeo, 1e5);

    console.log('writing', filename, iso_a3, countryFeatures.length);

    return jsonfile.writeFile(filename, countryTopo);
  })
).then(() => console.log('all done'));
