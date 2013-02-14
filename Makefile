TOPOJSON = ./node_modules/topojson/bin/topojson

COLLECTIONS = \
	ne_10m_admin_0_countries \
	ne_10m_admin_0_countries_lakes

all: node_modules $(addprefix topo/,$(addsuffix .json,$(COLLECTIONS)))

node_modules:
	npm install

zip/%.zip:
	mkdir -p $(dir $@) && curl "http://www.nacis.org/naturalearth/$*.zip" -o $@.download && mv $@.download $@

# Admin 0 – countries (8.4M)
shp/ne_10m_admin_0_countries.shp: zip/10m/cultural/ne_10m_admin_0_countries.zip
	mkdir -p $(dir $@) && unzip -d shp $< && touch $@

# Admin 0 – countries without boundary lakes (8.6M)
shp/ne_10m_admin_0_countries_lakes.shp: zip/10m/cultural/ne_10m_admin_0_countries_lakes.zip
	mkdir -p $(dir $@) && unzip -d shp $< && touch $@

geo/%.json: shp/%.shp
	mkdir -p geo && rm -f $@ && ogr2ogr -f GeoJSON $@ $<

topo/%.json: geo/%.json
	mkdir -p $(dir $@) && $(TOPOJSON) -o $@ -- $<
