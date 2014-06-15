include $(EASTER_ROOT)/make/common.mk
include $(PROJECT_ROOT)/easter.config
include $(PROJECT_ROOT)/easter.android.config

$(call assert_var architectures)
LIBMOAI_BUILD_DIR=$(COMMON_BUILD_DIR)/libmoai-android
LIBMOAI_MAKEFILES=$(architectures:%=$(LIBMOAI_BUILD_DIR)/%/Makefile)

APK_BUILD_DIR=$(HOST_BUILD_DIR)/apk
TEMPLATE_DIR=$(HOST_BUILD_DIR)/template
$(call assert_var project_name)
APK=$(APK_BUILD_DIR)/project/bin/$(project_name)-debug.apk
HOST_FILES=$(shell find $(HOST_DIR) -type f)

.PHONY: all

all: check-plugins check-moai-version $(LIBMOAI_MAKEFILES) $(APK_BUILD_DIR)
	$(foreach MAKEFILE,$(LIBMOAI_MAKEFILES),$(MAKE) -C $(dir $(MAKEFILE)) &&) true
	cp -rf $(LIBMOAI_BUILD_DIR)/libs/* $(APK_BUILD_DIR)/project/libs
	@cd $(APK_BUILD_DIR)/project && ant debug
	@cp $(APK) $(HOST_TARGET)

$(APK_BUILD_DIR): $(MOAI_SDK) $(HOST_FILES) $(PROJECT_ROOT)/easter.android.config
	@export MOAI_SDK=$(MOAI_SDK) && \
	 export APK_BUILD_DIR=$(APK_BUILD_DIR) && \
	 export HOST_DIR=$(HOST_DIR) && \
	 export TEMPLATE_DIR=$(TEMPLATE_DIR) && \
	 export PROJECT_ROOT=$(PROJECT_ROOT) && \
	 export PLUGIN_DIR=$(PLUGIN_DIR) && \
	 $(EASTER_ROOT)/scripts/create-android-project.sh

$(LIBMOAI_BUILD_DIR)/%/Makefile: ANDROID_ABI=$(shell basename $(dir $@))
$(LIBMOAI_BUILD_DIR)/%/Makefile: $(MOAI_SDK) $(PLUGIN_MANIFEST) $(PROJECT_ROOT)/easter.android.config | $(LIBMOAI_BUILD_DIR)/%/
	$(call assert_var android_ndk_root)
	$(info Arch: $(ANDROID_ABI))
	@cd $(dir $@) && \
	 cmake \
		-DDISABLED_EXT="" \
		-DMOAI_BOX2D=1 \
		-DMOAI_CHIPMUNK=1 \
		-DMOAI_CURL=1 \
		-DMOAI_CRYPTO=1 \
		-DMOAI_EXPAT=1 \
		-DMOAI_FREETYPE=1 \
		-DMOAI_HTTP_CLIENT=1 \
		-DMOAI_JSON=1 \
		-DMOAI_JPG=1 \
		-DMOAI_LUAEXT=1 \
		-DMOAI_MONGOOSE=1 \
		-DMOAI_OGG=1 \
		-DMOAI_OPENSSL=1 \
		-DMOAI_SQLITE3=1 \
		-DMOAI_TINYXML=1 \
		-DMOAI_PNG=1 \
		-DMOAI_SFMT=1 \
		-DMOAI_VORBIS=1 \
		-DMOAI_UNTZ=1 \
		-DMOAI_LUAJIT=1 \
		-DBUILD_ANDROID=true \
		-DCMAKE_TOOLCHAIN_FILE="$(MOAI_SDK)/cmake/host-android/android.toolchain.cmake" \
		-DANDROID_ABI=$(ANDROID_ABI) \
		-DANDROID_NDK=$(android_ndk_root)  \
		-DCMAKE_BUILD_TYPE=Release \
		-DLIBRARY_OUTPUT_PATH_ROOT=$(LIBMOAI_BUILD_DIR) \
		-DPLUGIN_DIR=$(PLUGIN_DIR) \
		$(PLUGIN_FLAGS) \
		$(MOAI_CMAKE_DIR)
