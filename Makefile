TOPOJSON = node_modules/.bin/topojson
TOPOMERGE = node_modules/.bin/topojson-merge

world-50m: shp/ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=iso_a3 \
		-p name,country \
		-- features=shp/ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp \
		| $(TOPOMERGE) \
			-o topo/world-50m.json \
			--io=features \
			--oo=land \
			--no-key

europe-50m: shp/europe_50m_admin_0_countries/europe_50m_admin_0_countries.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=iso_a3 \
		-p name,country \
		-- features=shp/europe_50m_admin_0_countries/europe_50m_admin_0_countries.shp \
		| $(TOPOMERGE) \
			-o topo/europe-50m.json \
			--io=features \
			--oo=land \
			--no-key

nielsen-dma: shp/nielsen-dma/nielsen-dma.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=id \
		-p name,country,metro \
		-- features=shp/nielsen-dma/nielsen-dma.shp \
		| $(TOPOMERGE) \
			-o topo/us-dma-50m.json \
			--io=features \
			--oo=land \
			--no-key

nielsen-dma-complete: shp/nielsen-dma-complete/nielsen-dma-complete.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=id \
		-p name,country,metro \
		-- features=shp/nielsen-dma-complete/nielsen-dma-complete.shp \
		| $(TOPOMERGE) \
			-o topo/us-dma-50m-complete.json \
			--io=features \
			--oo=land \
			--no-key

usa-states-50m: shp/usa-states-50m/usa-states-50m.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=iso_3166_2 \
		-p name,country,region \
		-- features=shp/usa-states-50m/usa-states-50m.shp \
		| $(TOPOMERGE) \
			-o topo/us-states-50m.json \
			--io=features \
			--oo=land \
			--no-key

europe-10m-country-regions: shp/europe-10m-country-regions/europe-regions.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e3 \
		--id-property=adm1_code \
		-p area,area_reg \
		-- regions=shp/europe-10m-country-regions/europe-regions.shp \
		| $(TOPOMERGE) \
			-o topo/europe-regions-10m.json \
			--io=regions \
			--oo=land \
			--no-key
