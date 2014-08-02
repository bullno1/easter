# config

## Syntax

	easter config [key] [value]

This command can be used to show or set easter's configuration

## Description

### Show all configuration variables

	easter config

### Show a single configuration variable

	easter config <key>

For example:

	easter config moai_root

### Set a configuration variable

	easter config <key> <value>

For example:

	easter config android_sdk_root /opt/android-sdk

In a Linux environment, most variables can be configured automatically with [auto-config](auto-config.md)

## Available configuration options

* `moai_root`: full path to Moai SDK
* `android_sdk_root`: full path to Android SDK
* `android_ndk_root`: full path to Android NDK
