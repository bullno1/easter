SDK_DIR=$(COMMON_BUILD_DIR)/moai-sdk
SDK_CMAKE_DIR=$(SDK_DIR)/cmake
MOAI_SDK=$(SDK_CMAKE_DIR)/CMakeLists.txt
NUM_CORES=$(shell grep --count processor /proc/cpuinfo)
MAKEFILE=$(HOST_BUILD_DIR)/Makefile
PLUGIN_DIR=$(PROJECT_ROOT)/plugins
PLUGINS=$(sort $(shell find $(PLUGIN_DIR) -maxdepth 1 -mindepth 1 -type d -exec basename {} \;))
PLUGIN_MANIFEST=$(COMMON_BUILD_DIR)/.plugins
PLUGINS_UPPERCASE=$(shell echo $(PLUGINS) | tr a-z A-Z)
PLUGIN_FLAGS=$(PLUGINS_UPPERCASE:%=-DPLUGIN_%=1)
OLD_PLUGINS=$(sort $(shell cat $(PLUGIN_MANIFEST) 2> /dev/null))

str_equal=$(and $(findstring $(1),$(2)),$(findstring $(2),$(1)))
assert_var=$(if $($(1)),,$(error "$(1) is not set"))

include $(PROJECT_ROOT)/easter.config
include ~/.easter

.PHONY: check-plugins

check-plugins:
	$(if $(call str_equal,$(PLUGINS),$(OLD_PLUGINS)),,$(shell rm $(PLUGIN_MANIFEST)))

$(MOAI_SDK): $(PROJECT_ROOT)/easter.config
	$(call assert_var,MOAI_VERSION)
	$(call assert_var,MOAI_ROOT)
	@rm -rf $(SDK_DIR)
	@mkdir -p $(SDK_DIR)
	@echo "Installing Moai SDK version $(MOAI_VERSION)"
	@git --git-dir=$(MOAI_ROOT)/.git read-tree Version-$(MOAI_VERSION)
	@git --git-dir=$(MOAI_ROOT)/.git checkout-index -a --prefix=$(SDK_DIR)/
	@git --git-dir=$(MOAI_ROOT)/.git read-tree HEAD

$(PLUGIN_MANIFEST): | $(dir $(PLUGIN_MANIFEST))
	@echo "Building plugin manifest"
	@echo $(PLUGINS) > $@

%/:
	mkdir -p $@
