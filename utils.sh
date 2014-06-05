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
	assert_file -f ./easter.config
	. ./easter.config
}

assert_var () {
	if [ -z ${!1} ]; then
		echo "$1 is not set"
		exit 1
	fi
}
