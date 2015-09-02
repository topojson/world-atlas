# World Atlas TopoJSON

This repository provides a convenient mechanism for generating TopoJSON files from [Natural Earth](http://naturalearthdata.com/).

## Installing via Homebrew

Before you can run `make`, you’ll need to install Node.js and `ogr2ogr`. Here’s how to do that using [Homebrew](http://mxcl.github.com/homebrew/) on Mac OS X:

```bash
brew install node gdal
```

And then, from this repository’s root directory, install the dependencies:

```bash
npm install
```

If the installation of [node-canvas](https://github.com/learnboost/node-canvas) fails for you, try

```bash
PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig npm install canvas
```

Or, add this to your ~/.bash_profile:

```bash
export PKG_CONFIG_PATH="/opt/X11/lib/pkgconfig"
```

If you want to install this software using an alternate method see the website for [TopoJSON](https://github.com/mbostock/topojson). I also recommend reading my tutorial, [Let’s Make a Map](http://bost.ocks.org/mike/map/).

## Make Targets

<b>topo/world-10m.json</b>

Admin 0 country boundaries at 1:10,000,000 scale.

<b>topo/world-50m.json</b>

Admin 0 country boundaries at 1:50,000,000 scale.

<b>topo/world-110m.json</b>

Admin 0 country boundaries at 1:110,000,000 scale.

If you want to generate a custom map, I recommend modifying the Makefile. Or, just use the Makefile as a set of examples, and run the appropriate `ogr2ogr` and `topojson` commands from the terminal. Or checkout [this repository](https://github.com/melalj/topojson-map-generator)) that provides a Bash version of the Makefile with more customizable parameters and pre-projected maps.
