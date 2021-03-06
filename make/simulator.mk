OS=$(shell uname | tr a-z A-Z)
LINUX_FLAGS=-DBUILD_LINUX=TRUE
OS_FLAGS=$($(OS)_FLAGS)
$(if $(OS_FLAGS),,$(error Unsupported platform: $(OS)))

MAKEFILE=$(HOST_BUILD_DIR)/Makefile

include $(EASTER_ROOT)/make/common.mk

.PHONY: all

all: check-plugins check-moai-version $(MAKEFILE)
	$(MAKE) -C $(dir $(MAKEFILE))

$(MAKEFILE): $(MOAI_SDK) $(PLUGIN_MANIFEST) | $(HOST_BUILD_DIR)/
	@echo "Generating Makefile"
	@cd $(HOST_BUILD_DIR) && \
	cmake \
	$(OS_FLAGS) \
	-DSDL_HOST=TRUE \
	-DMOAI_BOX2D=TRUE \
	-DMOAI_CHIPMUNK=TRUE \
	-DMOAI_CURL=TRUE \
	-DMOAI_CRYPTO=TRUE \
	-DMOAI_EXPAT=TRUE \
	-DMOAI_FREETYPE=TRUE \
	-DMOAI_JSON=TRUE \
	-DMOAI_JPG=TRUE \
	-DMOAI_MONGOOSE=TRUE \
	-DMOAI_LUAEXT=TRUE \
	-DMOAI_OGG=TRUE \
	-DMOAI_OPENSSL=TRUE \
	-DMOAI_SQLITE3=TRUE \
	-DMOAI_TINYXML=TRUE \
	-DMOAI_PNG=TRUE \
	-DMOAI_SFMT=TRUE \
	-DMOAI_VORBIS=TRUE \
	-DMOAI_UNTZ=TRUE \
	-DMOAI_LUAJIT=TRUE \
	-DMOAI_HTTP_CLIENT=TRUE \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
	-DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE) \
	-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=$(OUT_DIR) \
	-DCUSTOM_HOST=$(HOST_SRC_DIR)/cmake \
	-DPLUGIN_DIR=$(PLUGIN_DIR) \
	$(PLUGIN_FLAGS) \
	$(MOAI_CMAKE_DIR)
