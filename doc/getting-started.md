# Getting started

## Prerequisites

* git
* Android SDK
* Android NDK
* Moai SDK
* CMake
* GNU Make

## Installation

First, clone easter:

	git clone git://github.com/bullno1/easter.git

The `easter` needs to be put in a folder mentiond in the PATH environment variable.
Symlink can be used to make updating `easter` easier.
One possible way to install easter is to do:

	cd easter
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

## First project

To create a project, use the [new-project](new-project.md) command.

	mkdir hello-easter
	cd hello-easter
	easter new-project hello-easter

Now let's add a host to this project:

	git init .
	git submodule add git://github.com/bullno1/titan.git hosts/titan

Build and run the host:

	easter run titan -t src/main.lua

This instructs `easter` to [build](build.md) and [run](run.md) the host named `titan` with the parameters `-t src/main.lua`.
The parameters tells `titan` to run `src/main.lua` and quits.
For now, let's not focus too much on that.

For the first run, it will take a while because it will build the whole Moai SDK!
Subsequent runs will be much faster.
After a few minutes, depending on your machine, the terminal will show:

	-------------------------------
	Initializing Titan
	-------------------------------
	Hello world

Now, let's make our "app" work on Android.
To do that, we need to add an Android host with the [setup-android](setup-android.md) command:

	easter setup-android android

As you may have guess, to run it on Android, we only have to execute `easter run android`.
But to save time, let's just build it for one ARM architecture.
Open [easter.config.android](project-config.md#android-configurations) and edit the line that says:

	architectures=armeabi-v7a armeabi

To just:

	architectures=armeabi

Now, plug in your Android device and run:

	easter run android

After another ~~eternity~~ few minutes of waiting, your device will unlock and show a black screen (yay!!).
The terminal window will show ~~a bunch of giberrish~~ helpful debug messages which includes:

	I/MoaiLog (12818): MoaiRenderer runScripts: Running init.lua script
	I/MoaiLog (12818): load:        running init.lua
	I/MoaiLog (12818): MoaiRenderer runScripts: Running lua/main.lua script
	I/MoaiLog (12818): Hello world

To make this "app" "network-capable", let's add a network [plugin](plugins.md):

	git submodule add git://github.com/bullno1/moai-enet.git plugins/moai-enet

To know whether the plugin is integrated correctly, add one line to `src/main.lua`:

	print("enet:", enet)

First, verify if it works on the simulator:

	easter run titan -t src/main.lua

	## Expected output (table's address is not important):

	-------------------------------
	Initializing Titan
	-------------------------------
	Hello world
	enet:   table: 0x4191c798

Then, let's test on a real device:

	easter run android

	## Expected output

	...
	I/MoaiLog (13389): MoaiRenderer runScripts: Running lua/main.lua script
	I/MoaiLog (13389): Hello world
	I/MoaiLog (13389): enet:        table: 0x5c358008

Congratulations! Now you have an app that does nothing but has the abiliity to send optionally reliable UDP messages.
How cool is that?

More detailed documentation can be found [here](index.md#general-usage).
