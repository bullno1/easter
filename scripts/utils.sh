assert_file () {
	if [ ! $1 $2 ]; then
		echo "Cannot find $2"
		exit 1
	fi
}

read_config () {
	assert_file -f $1
	while read -r line; do
		local key="${line%=*}"
		local value="${line#*=}"
		eval "$key=\"$value\""
	done < $1
}

read_easter_config () {
	read_config $EASTER_CONFIG_FILE
}

read_project_config () {
	read_config "$PROJECT_ROOT/easter.config"
}

read_platform_config () {
	read_config "$PROJECT_ROOT/easter.$1.config"
}

assert_var () {
	if [ -z ${!1} ]; then
		echo "$1 is not set"
		exit 1
	fi
}

ensure_local_sdk () {
	make moai-sdk -f "$EASTER_ROOT/make/common.mk"
	MOAI_SDK="$COMMON_BUILD_DIR/moai-sdk"
}
