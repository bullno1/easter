# Plugins

All plugins must be placed inside the `plugins` folder.

`easter` automatically builds all plugins for all hosts.
It also detects addition, removal and modifications of plugins and does incremetal rebuild accordingly.

Plugin projects must follow Moai's plugin layout:

	<plugin-name>
	|-- CMakeLists.txt     # build configuration
	|-- <plugin-name>
	|   |-- CMakeLists.txt
	|   |-- host.cpp       # plugin interface implementation
	|   `-- host.h         # plugin interface declaration
	`-- plugin.CMake       # plugin declaration

For an example, checkout [moai-enet](https://github.com/bullno1/moai-enet)
