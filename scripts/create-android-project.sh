#!/bin/sh

set -o errexit
set -o errtrace
set -o nounset

. "$EASTER_ROOT/scripts/utils.sh"

read_easter_config
read_project_config
read_platform_config android

assert_var package
assert_var platform

# Create project template
rm -rf $MOAI_SDK/ant/untitled-host
rm -rf $MOAI_SDK/ant/libmoai/libs
$MOAI_SDK/ant/make-host.sh \
	-p $package \
	-s \
	-l $platform \
	--use-untz true \
	--use-luajit true > /dev/null 2> /dev/null
rm -rf $TEMPLATE_DIR/* 2> /dev/null
mkdir -p $TEMPLATE_DIR
cp -rf $MOAI_SDK/ant/untitled-host/* $TEMPLATE_DIR
rm -rf $TEMPLATE_DIR/host-source/project
rm -rf $TEMPLATE_DIR/host-source/init.lua
ln -s $HOST_DIR/project $TEMPLATE_DIR/host-source/project
ln -s $HOST_DIR/init.lua $TEMPLATE_DIR/host-source/init.lua

package_path=src/${package//\./\/}

rm -rf $APK_BUILD_DIR
mkdir -p $APK_BUILD_DIR/project
mkdir -p $APK_BUILD_DIR/project/assets

mkdir -p $APK_BUILD_DIR/project/libs

mkdir -p $APK_BUILD_DIR/project/res
cp -rf $TEMPLATE_DIR/host-source/project/res/* $APK_BUILD_DIR/project/res

link_icon () {
	local ICON_DIR=$APK_BUILD_DIR/project/res/drawable-${1}
	mkdir -p $ICON_DIR
	ln -s $PROJECT_ROOT/assets.android/icon-${1}.png $ICON_DIR/icon.png
}

link_icon ldpi
link_icon mdpi
link_icon hdpi
link_icon xhdpi
link_icon xxhdpi

cp -f $TEMPLATE_DIR/host-source/project/.classpath $APK_BUILD_DIR/project/.classpath
cp -f $TEMPLATE_DIR/host-source/project/proguard.cfg $APK_BUILD_DIR/project/proguard.cfg

mkdir -p $APK_BUILD_DIR/project/$package_path

function fr () {
	sed -i s%"$2"%"$3"%g $1
}

assert_var project_name
fr $APK_BUILD_DIR/project/res/values/strings.xml @NAME@ $project_name
assert_var app_id
fr $APK_BUILD_DIR/project/res/values/strings.xml @APP_ID@ $app_id

cp -f $TEMPLATE_DIR/host-source/project/.project $APK_BUILD_DIR/project/.project
fr $APK_BUILD_DIR/project/.project @NAME@ $project_name

cp -f $TEMPLATE_DIR/host-source/project/build.xml $APK_BUILD_DIR/project/build.xml
fr $APK_BUILD_DIR/project/build.xml @NAME@ $project_name

cp -f $TEMPLATE_DIR/host-source/project/AndroidManifest.xml $APK_BUILD_DIR/project/AndroidManifest.xml
debug=true
fr $APK_BUILD_DIR/project/AndroidManifest.xml @DEBUGGABLE@ $debug
assert_var version_code
fr $APK_BUILD_DIR/project/AndroidManifest.xml @VERSION_CODE@ $version_code
assert_var version_name
fr $APK_BUILD_DIR/project/AndroidManifest.xml @VERSION_NAME@ $version_name

cp -f $TEMPLATE_DIR/host-source/project/ant.properties $APK_BUILD_DIR/project/ant.properties
#fr $APK_BUILD_DIR/project/ant.properties @KEY_STORE@ "$key_store"
#fr $APK_BUILD_DIR/project/ant.properties @KEY_ALIAS@ "$key_alias"
#fr $APK_BUILD_DIR/project/ant.properties @KEY_STORE_PASSWORD@ "$key_store_password"
#fr $APK_BUILD_DIR/project/ant.properties @KEY_ALIAS_PASSWORD@ "$key_alias_password"

cp -f $TEMPLATE_DIR/host-source/project/project.properties $APK_BUILD_DIR/project/project.properties

dependency_index=1
requires=(${requires// / })
for (( i=0; i<${#requires[@]}; i++ )); do
	library=${requires[$i]}
	if ! [[ $library =~ ^[a-zA-Z0-9_\-]+$ ]]; then
		echo -e "*** Illegal optional component specified: $library, skipping..."
		echo -e "    > Optional component references may only contain letters, numbers, dashes and underscores"
		echo
		continue
	fi
	if [ -f $TEMPLATE_DIR/host-source/external/$library/manifest_declarations.xml ]; then
		awk 'FNR==NR{ _[++d]=$0; next } /EXTERNAL DECLARATIONS:/ { print; print ""; for ( i=1; i<=d; i++ ) { print _[i] } next } 1' $TEMPLATE_DIR/host-source/external/$library/manifest_declarations.xml $APK_BUILD_DIR/project/AndroidManifest.xml > /tmp/AndroidManifest.tmp && mv -f /tmp/AndroidManifest.tmp $APK_BUILD_DIR/project/AndroidManifest.xml
	fi
	if [ -f $TEMPLATE_DIR/host-source/external/$library/manifest_permissions.xml ]; then
		awk 'FNR==NR{ _[++d]=$0; next } /EXTERNAL PERMISSIONS:/ { print; print ""; for ( i=1; i<=d; i++ ) { print _[i] } next } 1' $TEMPLATE_DIR/host-source/external/$library/manifest_permissions.xml $APK_BUILD_DIR/project/AndroidManifest.xml > /tmp/AndroidManifest.tmp && mv -f /tmp/AndroidManifest.tmp $APK_BUILD_DIR/project/AndroidManifest.xml
	fi
	if [ -f $TEMPLATE_DIR/host-source/external/$library/classpath.xml ]; then
		awk 'FNR==NR{ _[++d]=$0; next } /EXTERNAL ENTRIES:/ { print; print ""; for ( i=1; i<=d; i++ ) { print _[i] } next } 1' $TEMPLATE_DIR/host-source/external/$library/classpath.xml $APK_BUILD_DIR/project/.classpath > /tmp/.classpath.tmp && mv -f /tmp/.classpath.tmp $APK_BUILD_DIR/project/.classpath
	fi
	if [ -d $TEMPLATE_DIR/host-source/moai/$library ]; then
		pushd $TEMPLATE_DIR/host-source/moai/$library > /dev/null
			find . -name ".?*" -type d -prune -o -type f -print0 | cpio -pmd0 --quiet $APK_BUILD_DIR/project/src/com/ziplinegames/moai
		popd > /dev/null
	fi
	if [ -d $TEMPLATE_DIR/host-source/external/$library/project ]; then
		pushd $TEMPLATE_DIR/host-source/external/$library/project > /dev/null
			find . -name ".?*" -type d -prune -o -type f -print0 | cpio -pmd0 --quiet $APK_BUILD_DIR/$library
		popd > /dev/null
		echo "android.library.reference.${dependency_index}=../$library/" >> $APK_BUILD_DIR/project/project.properties
		dependency_index=$(($dependency_index+1))
	fi
	if [ -d $TEMPLATE_DIR/host-source/external/$library/lib ]; then
		pushd $TEMPLATE_DIR/host-source/external/$library/lib > /dev/null
			find . -name ".?*" -type d -prune -o -type f -print0 | cpio -pmd0 --quiet $APK_BUILD_DIR/project/libs
		popd > /dev/null
	fi
	if [ -d $TEMPLATE_DIR/host-source/external/$library/src ]; then
		pushd $TEMPLATE_DIR/host-source/external/$library/src > /dev/null
			find . -name ".?*" -type d -prune -o -type f -print0 | cpio -pmd0 --quiet $APK_BUILD_DIR/project/src
		popd > /dev/null
	fi
done

assert_var package
fr $APK_BUILD_DIR/project/AndroidManifest.xml @PACKAGE@ $package
assert_var screen_orientation
fr $APK_BUILD_DIR/project/AndroidManifest.xml @SCREEN_ORIENTATION@ $screen_orientation

cp -f $TEMPLATE_DIR/host-source/project/local.properties $APK_BUILD_DIR/project/local.properties
assert_var android_sdk_root
for file in `find $APK_BUILD_DIR/ -name "local.properties"` ; do fr $file @SDK_ROOT@ $android_sdk_root ; done

cp -rf $TEMPLATE_DIR/host-source/project/src $APK_BUILD_DIR/project/

fr $APK_BUILD_DIR/project/$package_path/MoaiActivity.java @WORKING_DIR@ ""
for file in `find $APK_BUILD_DIR/project/$package_path/ -name "*.java"` ; do fr $file @PACKAGE@ "$package" ; done

run_command='runScripts(new String [] { "init.lua", "lua/main.lua" } );'

fr $APK_BUILD_DIR/project/$package_path/MoaiView.java @RUN_COMMAND@ "$run_command"

luajit -bg $TEMPLATE_DIR/host-source/init.lua $APK_BUILD_DIR/project/assets/init.lua

ln -s $PROJECT_ROOT/src $APK_BUILD_DIR/project/assets/lua
ln -s $PROJECT_ROOT/assets $APK_BUILD_DIR/project/assets/assets
