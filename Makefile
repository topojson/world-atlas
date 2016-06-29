TOPOJSON = node_modules/.bin/topojson
TOPOMERGE = node_modules/.bin/topojson-merge

all:

europe-50m: shp/europe_50m_admin_0_countries/europe_50m_admin_0_countries.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=+iso_n3 \
		-- countries=shp/europe_50m_admin_0_countries/europe_50m_admin_0_countries.shp \
		| $(TOPOMERGE) \
			-o topo/europe-50m.json \
			--io=countries \
			--oo=land \
			--no-key
