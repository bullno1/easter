# Project configuration

## Introduction

`easter` relies on several config files at the root folder of the project.
A config file is a text file with the following syntax:

	key1=value1
	key2=value2

Currently, the following config files are recognized:

* [easter.config](#common-configurations): common configuration for the whole project
* [easter.android.config](#android-configurations): Android-specific configuration

In the future, where more platforms are supported, platform-specific configuration files will follow the form `easter.<platform>.config`. (e.g: `easter.ios.config`)

## Common configurations

### project_name

Name of the project.
This will be used for various things such as apk name in an Android project.

Default value: `easter-sample`.

### moai_version

The Moai version to build the project against.
If you have done some private modifications to Moai, cd into the project and use `git describe` to obtain the version.
For example:

	git describe
	Version-1.5.2-1-g2a058bd

`moai_version` should be set to `1.5.2-1-g2a058bd` in this case.

Default value: `1.5.2`.

### package

The package name of the project, similar to a Java package name.

This is mostly used for generating an Android project but it can be useful for future platforms.
`package` should uniquely identifies your project from other developers.

Default value: `com.rubycell.sample`

## Android configurations

### platform

Android platform to build the project against.

Default value: `android-10`.

### app_id

App's id for IAP. Refer to Android SDK's documentation for more info.

Default value: `000`

### version_code

Refer to Android SDK's documentation for more info.

Default value: `1`.

### version_name

Refer to Android SDK's documentation for more info.

Default value: `1.0`.

### screen_orientation

Default orientation.

Accepted values are:

* `landscape`
* `portrait`

Default value: `landscape`.

### requires

A list of extensions. Refer to Moai's documentation for more info.

Items in the list can be a combination of:

* `miscellaneous`
* `adcolony`
* `google-billing`
* `chartboost`
* `crittercism`
* `facebook`
* `google-push`
* `tapjoy`
* `twitter`
* `google-play-services`

By default, all extensions are enabled, you can delete what you do not need from the list.

### architectures

A list of architectures to support. Refer to Android NDK's documentation for more info.

Items in the list can be a combination of:

* `armeabi-v7a`
* `armeabi`
* `x86`

Default value: `armeabi-v7a armeabi`
