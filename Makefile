TOPOJSON = ./node_modules/topojson/bin/topojson

COLLECTIONS = \
	ne_10m_admin_0_countries \
	ne_10m_admin_0_countries_lakes \
	ne_10m_admin_1_states_provinces \
	ne_10m_admin_1_states_provinces_lakes \
	ne_10m_us_states \
	ne_10m_us_states_lakes

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
# - removes the redundant _shp suffix for consistency
shp/ne_10m_admin_1_states_provinces.shp: zip/10m/cultural/ne_10m_admin_1_states_provinces_shp.zip
	mkdir -p $(dir $@) && unzip -d shp $<
	for file in shp/ne_10m_admin_1_states_provinces_shp.*; do mv $$file shp/ne_10m_admin_1_states_provinces"$${file#*_shp}"; done
	touch $@

# Admin 1 - states, provinces without large lakes (14.11M)
# - removes the redundant _shp suffix for consistency
shp/ne_10m_admin_1_states_provinces_lakes.shp: zip/10m/cultural/ne_10m_admin_1_states_provinces_lakes_shp.zip
	mkdir -p $(dir $@) && unzip -d shp $<
	for file in shp/ne_10m_admin_1_states_provinces_lakes_shp.*; do mv $$file shp/ne_10m_admin_1_states_provinces_lakes"$${file#*_shp}"; done
	touch $@

geo/%.json: shp/%.shp
	mkdir -p geo && rm -f $@ && ogr2ogr -f GeoJSON $@ $<

geo/ne_10m_us_states.json: shp/ne_10m_admin_1_states_provinces.shp
	rm -f $@ && ogr2ogr -f 'GeoJSON' -where "iso_a2 = ('US')" $@ $<

topo/ne_10m_us_states.json: geo/ne_10m_us_states.json
	$(TOPOJSON) -q 1e5 --id-property=postal -p name -s 7e-7 -o $@ -- states=$<

geo/ne_10m_us_states_lakes.json: shp/ne_10m_admin_1_states_provinces_lakes.shp
	rm -f $@ && ogr2ogr -f 'GeoJSON' -where "iso_a2 = ('US')" $@ $<

topo/ne_10m_us_states_lakes.json: geo/ne_10m_us_states_lakes.json
	$(TOPOJSON) -q 1e5 --id-property=postal -p name -s 7e-7 -o $@ -- states=$<

topo/%.json: geo/%.json
	mkdir -p $(dir $@) && $(TOPOJSON) -o $@ -- $<
