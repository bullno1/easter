# easter

easter is a build tool for [Moai game engine](http://github.com/moai/moai-dev). It automates repetitive and tedious tasks while building games with Moai.

easter was built with very specific requirements in mind:

* Fast incremental build
* Support repeatable build across machines
* Support development of native plugins concurrently with game project
* No external dependencies except common Unix tools and what Moai itself requires (e.g: cmake, android-sdk, android-ndk...)

# Installation and setup

The `easter` script needs to be put in a folder mentiond in the PATH environment variable.
Symlink can be used to make updating easter easier.
One possible way to install easter is to execute:

	sudo ln -s /usr/local/bin/easter `pwd`/easter

`easter` needs to be configured once before it can be used.
The fastest way is to use the `auto-config` command inside Moai's git folder:

	cd ~/Libraries/moai-dev ## or wherever you cloned Moai to
	easter auto-config

	## Expected output should be similar to this:

	Found Android SDK at: /opt/android-sdk
	Found Android NDK at: /opt/android-ndk
	Found LuaJIT at: /usr/bin/luajit
	Found Moai SDK at: /home/bullno1/Libraries/moai-dev

For more information on configuration, see [config](config.md)

# General usage

	easter <command> [parameters]

Available commands:

| Command                          | Description                               |
|----------------------------------|-------------------------------------------|
|[config](config.md)               | change/retrieve configuration variables   |
|[auto-config](auto-config.md)     | automatically set configuration variables |
|[new-project](new-project.md)     | setup a new project                       |
|[logcat](logcat.md)               | view your program's output through adb    |
|[build](build.md)                 | build your project                        |
|[run](run.md)                     | build and run your project                |
|[setup-android](setup-android.md) | setup a default Android host              |
|[debug](debug.md)                 | build and run your project in debug mode  |
