build_host () {
	. "$EASTER_ROOT/utils.sh"
	read_easter_config
	assert_var MOAI_ROOT

	mkdir -p $1
	local BUILD_DIR=`readlink -f $1`
	local HOST_DIR=`readlink -f $2`
	local PLUGIN_DIR=`readlink -f $3`
	mkdir -p $4
	local BIN_DIR=`readlink -f $4`
	local NUM_CORES=`grep --count processor /proc/cpuinfo`
	local PLUGINS=`find $PLUGIN_DIR -maxdepth 1 -mindepth 1 -type d -exec basename {} \;`
	PLUGINS=(${PLUGINS// /})
	local PLUGIN_FLAGS=()
	for i in "${PLUGINS[@]}"
	do
		PLUGIN_FLAGS+=("-DPLUGIN_`echo $i | tr [a-z] [A-Z]`=1")
	done

	cd $BUILD_DIR
	cmake \
	-DBUILD_LINUX=TRUE \
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
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=$BIN_DIR \
	-DCUSTOM_HOST="$HOST_DIR/cmake" \
	-DPLUGIN_DIR="$PLUGIN_DIR" \
	${PLUGIN_FLAGS[@]} \
	$MOAI_ROOT/cmake

	make -j$NUM_CORES
}
