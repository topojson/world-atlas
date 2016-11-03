# World Atlas TopoJSON

This repository provides a convenient mechanism for generating TopoJSON files from [Natural Earth](http://www.naturalearthdata.com/)’s [vector data](http://www.naturalearthdata.com/downloads/), version 2.0.0.

### Usage

In a browser (using [d3-geo](https://github.com/d3/d3-geo) and Canvas), [bl.ocks.org/3783604](https://bl.ocks.org/mbostock/3783604):

```html
<!DOCTYPE html>
<canvas width="960" height="500"></canvas>
<script src="https://d3js.org/d3.v4.min.js"></script>
<script src="https://d3js.org/topojson.v2.min.js"></script>
<script>

var context = d3.select("canvas").node().getContext("2d"),
    path = d3.geoPath(d3.geoOrthographic(), context);

d3.json("https://d3js.org/world-110m.v1.json", function(error, world) {
  if (error) throw error;

  context.beginPath();
  path(topojson.mesh(world));
  context.stroke();
});

</script>
```

In Node (using [d3-geo](https://github.com/d3/d3-geo) and [node-canvas](https://github.com/Automattic/node-canvas)), [bl.ocks.org/885fffe88d72b2a25c090e0bbbef382f](https://bl.ocks.org/mbostock/885fffe88d72b2a25c090e0bbbef382f):

```js
var fs = require("fs"),
    d3 = require("d3-geo"),
    topojson = require("topojson-client"),
    Canvas = require("canvas"),
    world = require("./node_modules/world-atlas/world/110m.json");

var canvas = new Canvas(960, 500),
    context = canvas.getContext("2d"),
    path = d3.geoPath(d3.geoOrthographic(), context);

context.beginPath();
path(topojson.mesh(world));
context.stroke();

canvas.pngStream().pipe(fs.createWriteStream("preview.png"));
```

## File Reference

<a href="#world/110m.json" name="world/110m.json">#</a> <b>world/110m.json</b> [<>](https://d3js.org/world-110m.v1.json "Source")

A [TopoJSON *topology*](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing two geometry collections: <i>countries</i> and <i>land</i>. The geometry is quantized, but not projected; it is in spherical coordinates, decimal degrees. This topology is derived from the Natural Earth’s [Admin 0 country boundaries](http://www.naturalearthdata.com/downloads/110m-cultural-vectors/), 1:110m small scale, version 2.0.0. The land boundary is computed by [merging](https://github.com/topojson/topojson-client/blob/master/README.md#merge) countries, ensuring a consistent topology.

<a href="#world/110m.json_countries" name="world/110m.json_countries">#</a> *world*.objects.<b>countries</b>

<img src="https://raw.githubusercontent.com/topojson/world-atlas/master/img/world-110m-countries.png" width="480" height="300">

<a href="#world/110m.json_land" name="world/110m.json_land">#</a> *world*.objects.<b>land</b>

<img src="https://raw.githubusercontent.com/topojson/world-atlas/master/img/world-110m-land.png" width="480" height="300">

<a href="#world/50m.json" name="world/50m.json">#</a> <b>world/50m.json</b> [<>](https://d3js.org/world-50m.v1.json "Source")

Equivalent to [world/110m.json](#world/110m.json), but at 1:50m medium scale.

<a href="#world/50m.json_countries" name="world/50m.json_countries">#</a> *world*.objects.<b>countries</b>

<img src="https://raw.githubusercontent.com/topojson/world-atlas/master/img/world-50m-countries.png" width="480" height="300">

<a href="#world/50m.json_land" name="world/50m.json_land">#</a> *world*.objects.<b>land</b>

<img src="https://raw.githubusercontent.com/topojson/world-atlas/master/img/world-50m-land.png" width="480" height="300">
