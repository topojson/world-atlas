TOPOJSON = node_modules/.bin/topojson
TOPOMERGE = node_modules/.bin/topojson-merge

all:

world-50m: shp/ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=iso_a3 \
		-p name,continent \
		-- countries=shp/ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp \
		| $(TOPOMERGE) \
			-o topo/world-50m.json \
			--io=countries \
			--oo=land \
			--no-key

europe-50m: shp/europe_50m_admin_0_countries/europe_50m_admin_0_countries.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=iso_a3 \
		-p name \
		-- countries=shp/europe_50m_admin_0_countries/europe_50m_admin_0_countries.shp \
		| $(TOPOMERGE) \
			-o topo/europe-50m.json \
			--io=countries \
			--oo=land \
			--no-key

nielsen-dma: shp/nielsen-dma/nielsen-dma.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=id \
		-p name \
		-- dmas=shp/nielsen-dma/nielsen-dma.shp \
		| $(TOPOMERGE) \
			-o topo/nielsen-dma.json \
			--io=dmas \
			--oo=land \
			--no-key

usa-states-50m: shp/usa-states-50m/usa-states-50m.shp
	mkdir -p topo
	$(TOPOJSON) \
		--quantization 1e5 \
		--id-property=iso_3166_2 \
		-p name,country,region \
		-- states=shp/usa-states-50m/usa-states-50m.shp \
		| $(TOPOMERGE) \
			-o topo/usa-states-50m.json \
			--io=states \
			--oo=land \
			--no-key 
