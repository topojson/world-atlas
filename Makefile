TOPOJSON = ./node_modules/topojson/bin/topojson

COLLECTIONS = \
	ne_10m_admin_0_countries \
	ne_10m_admin_0_countries_lakes

all: node_modules $(addprefix topo/,$(addsuffix .json,$(COLLECTIONS)))

node_modules:
	npm install

zip/%.zip:
	mkdir -p $(dir $@) && curl "http://www.nacis.org/naturalearth/$*.zip" -o $@.download && mv $@.download $@

# Admin 0 – countries (5.08M)
shp/ne_10m_admin_0_countries.shp: zip/10m/cultural/ne_10m_admin_0_countries.zip
	mkdir -p $(dir $@) && unzip -d shp $< && touch $@

# Admin 0 – countries without boundary lakes (5.26M)
shp/ne_10m_admin_0_countries_lakes.shp: zip/10m/cultural/ne_10m_admin_0_countries_lakes.zip
	mkdir -p $(dir $@) && unzip -d shp $< && touch $@

# Admin 1 - states, provinces (13.97M)
shp/ne_10m_admin_1_states_provinces_shp.shp: zip/10m/cultural/ne_10m_admin_1_states_provinces_shp.zip
	mkdir -p $(dir $@) && unzip -d shp $< && touch $@

# Admin 1 - states, provinces without large lakes (14.11M)
shp/ne_10m_admin_1_states_provinces_lakes_shp.shp: zip/10m/cultural/ne_10m_admin_1_states_provinces_lakes_shp.zip
	mkdir -p $(dir $@) && unzip -d shp $< && touch $@

geo/%.json: shp/%.shp
	mkdir -p geo && rm -f $@ && ogr2ogr -f GeoJSON $@ $<

geo/ne_10m_us_states_provinces_lakes_shp.json: shp/ne_10m_admin_1_states_provinces_lakes_shp.shp
	rm -f $@ && ogr2ogr -f 'GeoJSON' -where "iso_a2 = ('US')" $@ $<

topo/ne_10m_us_states_provinces_lakes_shp.json: geo/ne_10m_us_states_provinces_lakes_shp.json
	$(TOPOJSON) -q 1e5 --id-property=postal -p name -s 7e-7 -o $@ -- states=$<

topo/%.json: geo/%.json
	mkdir -p $(dir $@) && $(TOPOJSON) -o $@ -- $<
