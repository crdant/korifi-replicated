VERSION := 0.4.0

PROJECT_DIR := $(shell pwd)
CHANNEL     := Unstable

MANIFEST_DIR := $(PROJECT_DIR)/manifests
MANIFESTS    := $(shell find $(MANIFEST_DIR) -name '*.yaml' -o -name '*.tgz')

chart: 
	@helm pull https://github.com/cloudfoundry/korifi/releases/download/v$(VERSION)/korifi-$(VERSION).tgz
	@mv korifi-$(VERSION).tgz $(MANIFEST_DIR)

lint: $(MANIFESTS) chart
	@replicated release lint --yaml-dir $(MANIFEST_DIR)

release: $(MANIFESTS) chart
	@replicated release create \
		--app ${REPLICATED_APP} \
		--token ${REPLICATED_API_TOKEN} \
		--auto -y \
		--yaml-dir $(MANIFEST_DIR) \
		--promote $(CHANNEL)

install:
	@kubectl kots install ${REPLICATED_APP}
