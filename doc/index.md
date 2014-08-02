# easter

easter is a build tool for [Moai game engine](http://github.com/moai/moai-dev). It automates repetitive and tedious tasks while building games with Moai.

easter was built with very specific requirements in mind:

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

For more information on configuration, see [Config](config.md)
