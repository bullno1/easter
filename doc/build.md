# build

## Syntax

	easter build [build-type] <host-name>

## Description

Build a [host](hosts.md) using the given `build-type`.
Available build types are:

* `debug`: No optimizations, debug symbols generated.
* `develop`: Optimizations enabled, debug symbols generated. This is the default type.
* `release`: Optimizations enabled, no debug symbols generated.

If the build is successful, a binary of the given host will be created in `<project-root>/.build/bin/<build-type>/`.

Usually, one would use commands such as [run](run.md) or [debug](debug.md) instead.
