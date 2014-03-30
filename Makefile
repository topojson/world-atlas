TOPOJSON = node_modules/.bin/topojson
TOPOMERGE = node_modules/.bin/topojson-merge

all:

.SECONDARY:

zip/ne_10m_land.zip:
	mkdir -p $(dir $@)
	curl "http://www.nacis.org/naturalearth/10m/physical/ne_10m_land.zip" -o $@.download
	mv $@.download $@

zip/ne_10m_%.zip:
	mkdir -p $(dir $@)
	curl "http://www.nacis.org/naturalearth/10m/cultural/ne_10m_$*.zip" -o $@.download
	mv $@.download $@

zip/ne_50m_land.zip:
	mkdir -p $(dir $@)
	curl "http://www.nacis.org/naturalearth/50m/physical/ne_50m_land.zip" -o $@.download
	mv $@.download $@

zip/ne_50m_%.zip:
	mkdir -p $(dir $@)
	curl "http://www.nacis.org/naturalearth/50m/cultural/ne_50m_$*.zip" -o $@.download
	mv $@.download $@

zip/ne_110m_land.zip:
	mkdir -p $(dir $@)
	curl "http://www.nacis.org/naturalearth/110m/physical/ne_110m_land.zip" -o $@.download
	mv $@.download $@

zip/ne_110m_%.zip:
	mkdir -p $(dir $@)
	curl "http://www.nacis.org/naturalearth/110m/cultural/ne_110m_$*.zip" -o $@.download
	mv $@.download $@

# Admin 0 – land (3.17M)
shp/ne_%_land.shp: zip/ne_%_land.zip
	mkdir -p $(dir $@)
	unzip -d shp $<
	touch $@

# Admin 0 – countries (5.08M)
shp/ne_%_admin_0_countries.shp: zip/ne_%_admin_0_countries.zip
	mkdir -p $(dir $@)
	unzip -d shp $<
	touch $@

# Admin 0 – countries without boundary lakes (5.26M)
shp/ne_%_admin_0_countries_lakes.shp: zip/ne_%_admin_0_countries_lakes.zip
	mkdir -p $(dir $@)
	unzip -d shp $<
	touch $@

# Admin 1 - states, provinces (13.97M)
# - removes the redundant _shp suffix for consistency
shp/ne_%_admin_1_states_provinces.shp: zip/ne_%_admin_1_states_provinces_shp.zip
	mkdir -p $(dir $@)
	unzip -d shp $<
	for file in shp/ne_$*_admin_1_states_provinces_shp.*; do mv $$file shp/ne_$*_admin_1_states_provinces"$${file#*_shp}"; done
	touch $@

# Admin 1 - states, provinces without large lakes (14.11M)
# - removes the redundant _shp suffix for consistency
shp/ne_%_admin_1_states_provinces_lakes.shp: zip/ne_%_admin_1_states_provinces_lakes_shp.zip
	mkdir -p $(dir $@)
	unzip -d shp $<
	for file in shp/ne_$*_admin_1_states_provinces_lakes_shp.*; do mv $$file shp/ne_$*_admin_1_states_provinces_lakes"$${file#*_shp}"; done
	touch $@

topo/world-%.json: shp/ne_%_land.shp shp/ne_%_admin_0_countries.shp
	mkdir -p $(dir $@)
	$(TOPOJSON) -o $@.tmp -q 1e5 --id-property=+iso_n3 -- land=shp/ne_$*_land.shp countries=shp/ne_$*_admin_0_countries.shp
	$(TOPOMERGE) -o $@ --io=land --oo=land --no-key -- $@.tmp
	rm -f -- $@.tmp
