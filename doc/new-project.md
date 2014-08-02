# new-project

## Syntax

	easter new-project

## Description

Create a new project in the current folder using a pre-defined template.
Existing files will be __overwritten__ so make sure you have backed up any important files.

## Project structure

	.
	|-- assets                  # common assets
	|-- assets.android          # Android-specific assets
	|   |-- icon-hdpi.png
	|   |-- icon-ldpi.png
	|   |-- icon-mdpi.png
	|   |-- icon-xhdpi.png
	|   `-- icon-xxhdpi.png
	|-- easter.android.config   # Android-specific config
	|-- easter.config           # Project config
	|-- hosts                   # Hosts
	|-- plugins                 # Plugins
	`-- src                     # Source code
		`-- main.lua

## Related topics

* [Project common configurations](project-config.md#common-configurations)
* [Android-specific configurations](project-config.md#android-configurations)
* [Hosts](hosts.md)
* [Plugins](plugins.md)
