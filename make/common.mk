include $(PROJECT_ROOT)/easter.config
include ~/.easter

# Common variables
NUM_CORES=$(shell grep --count processor /proc/cpuinfo)
MAKE=make -j$(NUM_CORES)

# Common functions

str_equal=$(and $(findstring x$(1),x$(2)),$(findstring x$(2),x$(1)))
assert_var=$(if $($(1)),,$(error "$(1) is not set"))

## Moai SDK targets

MOAI_SDK=$(COMMON_BUILD_DIR)/moai-sdk
MOAI_CMAKE_DIR=$(MOAI_SDK)/cmake
MOAI_VERSION_MANIFEST=$(COMMON_BUILD_DIR)/.moai-version
OLD_MOAI_VERSION=$(shell cat $(MOAI_VERSION_MANIFEST) 2> /dev/null)

.PHONY: moai-sdk check-moai-version

moai-sdk: check-moai-version $(MOAI_SDK)

$(MOAI_SDK): $(MOAI_VERSION_MANIFEST)
	$(call assert_var,moai_version)
	$(call assert_var,moai_root)
	@rm -rf $(MOAI_SDK)
	@mkdir -p $(MOAI_SDK)
	@echo "Installing Moai SDK version $(moai_version)"
	@git --git-dir=$(moai_root)/.git read-tree Version-$(moai_version)
	@git --git-dir=$(moai_root)/.git checkout-index -a --prefix=$(MOAI_SDK)/
	@git --git-dir=$(moai_root)/.git read-tree HEAD

$(MOAI_VERSION_MANIFEST): | $(dir $(MOAI_VERSION_MANIFEST))
	@echo $(moai_version) > $@
	@echo "moai_version changed: $(OLD_MOAI_VERSION) -> $(moai_version)"

check-moai-version:
	$(if $(call str_equal,$(moai_version),$(OLD_MOAI_VERSION)),,$(shell rm $(MOAI_VERSION_MANIFEST) 2> /dev/null))

## Plugin targets
PLUGIN_DIR=$(PROJECT_ROOT)/plugins
PLUGINS=$(sort $(shell find $(PLUGIN_DIR) -maxdepth 1 -mindepth 1 -type d -exec basename {} \;))
PLUGIN_MANIFEST=$(COMMON_BUILD_DIR)/.plugins
PLUGINS_UPPERCASE=$(shell echo $(PLUGINS) | tr a-z A-Z)
PLUGIN_FLAGS=$(PLUGINS_UPPERCASE:%=-DPLUGIN_%=1)
OLD_PLUGINS=$(sort $(shell cat $(PLUGIN_MANIFEST) 2> /dev/null))

.PHONY: check-plugins

check-plugins:
	$(if $(call str_equal,$(PLUGINS),$(OLD_PLUGINS)),,$(shell rm $(PLUGIN_MANIFEST) 2> /dev/null))

$(PLUGIN_MANIFEST): | $(dir $(PLUGIN_MANIFEST))
	@echo $(PLUGINS) > $@
	@echo "Plugins changed"
	@echo "Old: $(OLD_PLUGINS)"
	@echo "New: $(PLUGINS)"

## Misc targets

%/:
	@mkdir -p $@
