MOAI_SDK=$(COMMON_BUILD_DIR)/moai-sdk
MOAI_CMAKE_DIR=$(MOAI_SDK)/cmake
NUM_CORES=$(shell grep --count processor /proc/cpuinfo)
PLUGIN_DIR=$(PROJECT_ROOT)/plugins
PLUGINS=$(sort $(shell find $(PLUGIN_DIR) -maxdepth 1 -mindepth 1 -type d -exec basename {} \;))
PLUGIN_MANIFEST=$(COMMON_BUILD_DIR)/.plugins
PLUGINS_UPPERCASE=$(shell echo $(PLUGINS) | tr a-z A-Z)
PLUGIN_FLAGS=$(PLUGINS_UPPERCASE:%=-DPLUGIN_%=1)
OLD_PLUGINS=$(sort $(shell cat $(PLUGIN_MANIFEST) 2> /dev/null))
MOAI_VERSION_MANIFEST=$(COMMON_BUILD_DIR)/.moai-version
OLD_MOAI_VERSION=$(shell cat $(MOAI_VERSION_MANIFEST) 2> /dev/null)
MAKE=make -j$(NUM_CORES)
LUA_FILES=$(wildcard $(PROJECT_ROOT)/src/**/*.lua) $(wildcard $(PROJECT_ROOT)/src/*.lua)
ASSET_FILES=$(wildcard $(PROJECT_ROOT)/assets/**/*)

str_equal=$(and $(findstring $(1),$(2)),$(findstring $(2),$(1)))
assert_var=$(if $($(1)),,$(error "$(1) is not set"))

include $(PROJECT_ROOT)/easter.config
include ~/.easter

.PHONY: check-plugins check-moai-version moai-sdk

moai-sdk: check-moai-version $(MOAI_SDK)

check-moai-version:
	$(if $(call str_equal,$(moai_version),$(OLD_MOAI_VERSION)),,$(shell rm $(MOAI_VERSION_MANIFEST) 2> /dev/null))

check-plugins:
	$(if $(call str_equal,$(PLUGINS),$(OLD_PLUGINS)),,$(shell rm $(PLUGIN_MANIFEST) 2> /dev/null))

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

$(PLUGIN_MANIFEST): | $(dir $(PLUGIN_MANIFEST))
	@echo $(PLUGINS) > $@
	@echo "Plugins changed"
	@echo "Old: $(OLD_PLUGINS)"
	@echo "New: $(PLUGINS)"

%/:
	@mkdir -p $@
