# Building

**Also note**: you should be familiar with the commandline. If not, read this [quick guide by ninjamuffin](https://ninjamuffin99.newgrounds.com/news/post/1090480).

**Also also note**: To build for _Windows_, you need to be on _Windows_. To build for _Linux_, you need to be on _Linux_. Same goes for macOS. You can build for html5/browsers on any platform.

## Instructions

### First steps

- Download Haxe from [Haxe.org](https://haxe.org)
- Download Git from [git-scm.com](https://www.git-scm.com)
- Run `haxelib --global install hmm` and then `haxelib --global run hmm setup` to install hmm.json
- Run `hmm install` to install all haxelibs of the current branch
- Run `lime rebuild extension-webm windows`

### Perform additional platform setup

- For Windows, download the [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
  - When prompted, select "Individual Components" and make sure to download the following:
    - MSVC v143 VS 2022 C++ x64/x86 build tools
    - Windows 10/11 SDK
- Mac: [`lime setup mac` Documentation](https://lime.openfl.org/docs/advanced-setup/macos/)
- Linux: [`lime setup linux` Documentation](https://lime.openfl.org/docs/advanced-setup/linux/)

### Last steps

- `lime test <PLATFORM>` to build and launch the game for your platform (for example, `lime test windows`)

## Troubleshooting

Check the **Troubleshooting documentation** if you have problems with these instructions.
