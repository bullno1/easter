# easter

easter is a build tool for [Moai game engine](http://github.com/moai/moai-dev). It automates repetitive and tedious tasks while building games with Moai.

easter was built with very specific requirements in mind:

* Fast incremental build
* Support repeatable build across machines
* Support development of native plugins concurrently with game project
* No external dependencies except common Unix tools and what Moai itself requires (e.g: cmake, android-sdk, android-ndk...)

For a quick start guide, checkout [doc/getting-started.md](doc/getting-started.md)

For more detailed documentation, checkout [doc/index.md](doc/index.md#general-usage)

To build documentations for offline reading, run `make`. [pandoc](http://johnmacfarlane.net/pandoc/) is required.
