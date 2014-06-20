export_build_vars() {
	export HOST_NAME=$1
	export BUILD_TYPE=$2

	case $BUILD_TYPE in
		release)
			export CMAKE_BUILD_TYPE=Release
			;;
		debug)
			export CMAKE_BUILD_TYPE=Debug
			;;
		develop)
			export CMAKE_BUILD_TYPE=RelWithDebInfo
			;;
		*)
			echo "Invalid build type: $BUILD_TYPE"
			exit 1
	esac

	export OUT_DIR="$COMMON_BUILD_DIR/bin/$BUILD_TYPE"
	export HOST_SRC_DIR="$PROJECT_ROOT/hosts/$HOST_NAME"
	export HOST_BUILD_DIR="$COMMON_BUILD_DIR/$HOST_NAME/$BUILD_TYPE"
}
