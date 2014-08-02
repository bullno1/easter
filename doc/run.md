# run

## Syntax

	easter run <host-name> [extra-args]

## Description

[build](build.md) the host with the name `host-name` in `develop` mode.
If it is succesful, run the host.

For [simulator hosts](hosts.md#simulator), it will be executed with the project's root folder as the working directory and `extra-args` will be passed to it.
Core dump will be enabled and debuggers such as gdb or nemiver can be used to analyze the dump if the host crashes.
Where the crash dump is located or how it is named varies from one distro to another.

For [android hosts](hosts.md#android), it will install the apk on the attached device, unlock the screen, launch it and show the program's output in the console.

## Examples

To run the `titan` host and make it execute `src/main.lua`:

	easter run titan src/main.lua

To run the `android` host:

	easter run android
