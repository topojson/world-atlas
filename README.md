# World Atlas TopoJSON

This repository provides a convenient redistribution of [Natural Earth](http://www.naturalearthdata.com/)’s [vector data](http://www.naturalearthdata.com/downloads/), version 4.1.0 as TopoJSON. For earlier editions, see [past releases](https://github.com/topojson/world-atlas).

### Usage

In a browser, using [d3-geo](https://github.com/d3/d3-geo) and Canvas:<br>
https://observablehq.com/@d3/world-map

In a browser, using [d3-geo](https://github.com/d3/d3-geo) and SVG:<br>
https://observablehq.com/@d3/world-map-svg

In Node, using [d3-geo](https://github.com/d3/d3-geo) and [node-canvas](https://github.com/Automattic/node-canvas):<br>
https://bl.ocks.org/mbostock/885fffe88d72b2a25c090e0bbbef382f

## File Reference

<a href="#countries-110m.json" name="countries-110m.json">#</a> <b>countries-110m.json</b> · [Download](https://cdn.jsdelivr.net/npm/world-atlas@2/countries-110m.json "Source")

A [TopoJSON file](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing the geometry collections <i>countries</i> and <i>land</i>. The geometry is quantized, but not projected; it is in spherical coordinates, decimal degrees. This topology is derived from the Natural Earth’s [Admin 0 country boundaries](http://www.naturalearthdata.com/downloads/110m-cultural-vectors/), 1:110m small scale. The land boundary is computed by [merging](https://github.com/topojson/topojson-client/blob/master/README.md#merge) countries, ensuring a consistent topology.

<a href="#countries-50m.json" name="countries-50m.json">#</a> <b>countries-50m.json</b> · [Download](https://cdn.jsdelivr.net/npm/world-atlas@2/countries-50m.json "Source")

A [TopoJSON file](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing the geometry collections <i>countries</i> and <i>land</i>. The geometry is quantized, but not projected; it is in spherical coordinates, decimal degrees. This topology is derived from the Natural Earth’s [Admin 0 country boundaries](http://www.naturalearthdata.com/downloads/50m-cultural-vectors/), 1:50m medium scale. The land boundary is computed by [merging](https://github.com/topojson/topojson-client/blob/master/README.md#merge) countries, ensuring a consistent topology.

<a href="#countries-10m.json" name="countries-10m.json">#</a> <b>countries-10m.json</b> · [Download](https://cdn.jsdelivr.net/npm/world-atlas@2/countries-10m.json "Source")

A [TopoJSON file](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing the geometry collections <i>countries</i> and <i>land</i>. The geometry is quantized, but not projected; it is in spherical coordinates, decimal degrees. This topology is derived from the Natural Earth’s [Admin 0 country boundaries](http://www.naturalearthdata.com/downloads/10m-cultural-vectors/), 1:10m large scale. The land boundary is computed by [merging](https://github.com/topojson/topojson-client/blob/master/README.md#merge) countries, ensuring a consistent topology.

<a href="#land-110m.json" name="land-110m.json">#</a> <b>land-110m.json</b> · [Download](https://cdn.jsdelivr.net/npm/world-atlas@2/land-110m.json "Source")

A [TopoJSON file](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing the geometry collection <i>land</i>. The geometry is quantized, but not projected; it is in spherical coordinates, decimal degrees. This topology is derived from the Natural Earth’s [land boundaries](http://www.naturalearthdata.com/downloads/110m-physical-vectors/), 1:110m small scale.

<a href="#land-50m.json" name="land-50m.json">#</a> <b>land-50m.json</b> · [Download](https://cdn.jsdelivr.net/npm/world-atlas@2/land-50m.json "Source")

A [TopoJSON file](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing the geometry collection <i>land</i>. The geometry is quantized, but not projected; it is in spherical coordinates, decimal degrees. This topology is derived from the Natural Earth’s [land boundaries](http://www.naturalearthdata.com/downloads/50m-physical-vectors/), 1:50m medium scale.

<a href="#land-10m.json" name="land-10m.json">#</a> <b>land-10m.json</b> · [Download](https://cdn.jsdelivr.net/npm/world-atlas@2/land-10m.json "Source")

A [TopoJSON file](https://github.com/topojson/topojson-specification/blob/master/README.md#21-topology-objects) containing the geometry collection <i>land</i>. The geometry is quantized, but not projected; it is in spherical coordinates, decimal degrees. This topology is derived from the Natural Earth’s [land boundaries](http://www.naturalearthdata.com/downloads/10m-physical-vectors/), 1:10m large scale.

<a href="#countries" name="countries">#</a> *world*.objects.<b>countries</b>

<img src="https://raw.githubusercontent.com/topojson/world-atlas/master/img/countries.png" width="480" height="300">

Each country has two fields:

* *country*.id - the three-digit [ISO 3166-1 numeric country code](https://en.wikipedia.org/wiki/ISO_3166-1_numeric), such as `"528"`
* *country*.properties.name - the country name, such as `"Netherlands"`

<a href="#land" name="land">#</a> *world*.objects.<b>land</b>

<img src="https://raw.githubusercontent.com/topojson/world-atlas/master/img/land.png" width="480" height="300">
