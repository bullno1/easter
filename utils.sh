read_easter_config () {
	. $EASTER_CONFIG_FILE
}

assert_file () {
	if [ ! $1 $2 ]; then
		echo "Cannot find $2"
		exit 1
	fi
}

read_project_config () {
	assert_file -f "$PROJECT_ROOT/easter.config"
	. "$PROJECT_ROOT/easter.config"
}

assert_var () {
	if [ -z ${!1} ]; then
		echo "$1 is not set"
		exit 1
	fi
}

ensure_local_sdk () {
	read_easter_config
	assert_var MOAI_ROOT
	read_project_config
	assert_var MOAI_VERSION

	if [ ! -f "$PROJECT_ROOT/build/moai-sdk/cmake/CMakeLists.txt" ]; then
		mkdir -p "$PROJECT_ROOT/build/moai-sdk"
		pushd $MOAI_ROOT
		git --work-tree="$PROJECT_ROOT/build/moai-sdk" checkout Version-$MOAI_VERSION -- .
		popd
	fi

	export LOCAL_SDK_PATH="$PROJECT_ROOT/build/moai-sdk"
}
