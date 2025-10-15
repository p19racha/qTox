# Building qTox on Ubuntu# Install Instructions



**qTox 2.0** is exclusively designed for Ubuntu Linux systems.- [Dependencies](#dependencies)

- [Linux](#linux)

## System Requirements  - [Simple install](#simple-install)

    - [Arch](#arch-easy)

- **Operating System**: Ubuntu 22.04 LTS or newer    - [Debian](#debian-easy)

- **Qt Version**: Qt 6.5 or newer    - [Fedora](#fedora-easy)

- **Display Server**: Wayland (preferred) or X11    - [Gentoo](#gentoo-easy)

- **Compiler**: GCC 13+ or Clang 16+    - [openSUSE](#opensuse-easy)

- **CMake**: 3.16 or newer    - [Slackware](#slackware-easy)

    - [Ubuntu](#ubuntu-easy)

---  - [Install git](#install-git)

    - [Arch](#arch-git)

## Quick Install (Ubuntu 22.04+)    - [Debian](#debian-git)

    - [Fedora](#fedora-git)

### Install Dependencies    - [openSUSE](#opensuse-git)

    - [Ubuntu](#ubuntu-git)

```bash  - [Clone qTox](#clone-qtox)

# Update package list  - [GCC, Qt, FFmpeg, OpenAL Soft and qrencode](#other-deps)

sudo apt update    - [Arch](#arch-other-deps)

    - [Debian](#debian-other-deps)

# Install build tools    - [Fedora](#fedora-other-deps)

sudo apt install -y build-essential cmake pkg-config git    - [openSUSE](#opensuse-other-deps)

    - [Slackware](#slackware-other-deps)

# Install Qt6 development packages    - [Ubuntu](#ubuntu-other-deps)

sudo apt install -y \  - [Compile dependencies](#compile-dependencies)

    qt6-base-dev \    - [docker](#docker)

    qt6-declarative-dev \    - [Compile toxcore](#compile-toxcore)

    qt6-multimedia-dev \  - [Compile qTox](#compile-qtox)

    qt6-svg-dev \  - [Security hardening with AppArmor](#security-hardening-with-apparmor)

    qt6-tools-dev \- [BSD](#bsd)

    libqt6opengl6-dev \  - [FreeBSD](#freebsd-easy)

    libqt6svg6- [macOS](#macos)

- [Windows](#windows)

# Install qTox dependencies  - [Cross-compile from Linux](#cross-compile-from-linux)

sudo apt install -y \  - [Native](#native)

    libtoxcore-dev \- [Compile-time switches](#compile-time-switches)

    libsqlcipher-dev \

    libavcodec-dev \## Dependencies

    libavdevice-dev \

    libavfilter-dev \| Name          | Version   | Modules                                          |

    libavformat-dev \| ------------- | --------- | ------------------------------------------------ |

    libavutil-dev \| [Qt]          | >= 6.2.0  | concurrent, core, gui, network, svg, widget, xml |

    libswscale-dev \| [GCC]/[MinGW] | >= 11     | C++17 enabled                                    |

    libopenal-dev \| [toxcore]     | >= 0.2.20 | core, av                                         |

    libexif-dev \| [FFmpeg]      | >= 2.6.0  | avformat, avdevice, avcodec, avutil, swscale     |

    libqrencode-dev \| [CMake]       | >= 3.10   |                                                  |

    libglib2.0-dev \| [OpenAL Soft] | >= 1.16.0 |                                                  |

    libvpx-dev \| [qrencode]    | >= 3.0.3  |                                                  |

    libopus-dev \| [sqlcipher]   | >= 3.2.0  |                                                  |

    libsodium-dev \| [pkg-config]  | >= 0.28   |                                                  |

    libx11-dev \

    libxss-dev## Optional dependencies



# Optional: spell checking supportThey can be disabled/enabled by passing arguments to `cmake` command when

sudo apt install -y libkf5sonnet-devbuilding qTox.



# Optional: build accelerationIf they are missing, qTox is built without support for the functionality.

sudo apt install -y ccache

```### Spell checking support



---| Name     | Version |

| -------- | ------- |

## Build from Source| [sonnet] | >= 6.0  |



### 1. Clone the RepositoryUse `-DSPELL_CHECK=OFF` to disable it.



```bash**Note:** Specified version was tested and works well. You can try to use older

git clone https://github.com/p19racha/qTox.gitversion, but in this case you may have some errors (including a complete lack

cd qToxof spell check).

```

### Linux

### 2. Configure Build

#### Auto-away support

```bash

mkdir build && cd build| Name            | Version  |

| --------------- | -------- |

# Standard build| [libXScrnSaver] | >= 1.2   |

cmake ..| [libX11]        | >= 1.6.0 |



# Or with options:Disabled if dependencies are missing during compilation.

cmake .. \

    -DCMAKE_BUILD_TYPE=Release \## Linux

    -DUSE_CCACHE=ON \

    -DSPELL_CHECK=ON \### Simple install

    -DUPDATE_CHECK=ON

```Easy qTox install is provided for variety of distributions:



**Build Options:**- [Arch](#arch)

- `CMAKE_BUILD_TYPE`: `Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`- [Debian](#debian)

- `USE_CCACHE`: Use ccache for faster rebuilds (`ON`/`OFF`)- [Fedora](#fedora)

- `SPELL_CHECK`: Enable spell checking support (`ON`/`OFF`)- [Gentoo](#gentoo)

- `UPDATE_CHECK`: Enable automatic update checking (`ON`/`OFF`)- [Slackware](#slackware)

- `BUILD_TESTING`: Build tests (`ON`/`OFF`)- [Ubuntu](#ubuntu)

- `CODE_COVERAGE`: Enable coverage reporting (`ON`/`OFF`)

- `ASAN`: Build with AddressSanitizer (`ON`/`OFF`)---

- `TSAN`: Build with ThreadSanitizer (`ON`/`OFF`)

- `UBSAN`: Build with UndefinedBehaviorSanitizer (`ON`/`OFF`)<a name="arch-easy" />



### 3. Compile#### Arch



```bashPKGBUILD is available in the [AUR](https://aur.archlinux.org/packages/qtox-toktok), install `qtox-toktok` with your AUR helper.

# Use all CPU cores

make -j$(nproc)<a name="debian-easy" />



# Or specify core count (e.g., 4 cores)#### Debian

make -j4

```qTox is available in the [Main](https://tracker.debian.org/pkg/qtox) repo, to install:



### 4. Install (Optional)```bash

sudo apt install qtox

```bash```

sudo make install

```<a name="fedora-easy" />



This installs to `/usr/local/bin/qtox` by default.#### Fedora



---qTox is available in the [RPM Fusion](https://rpmfusion.org/) repo, to install:



## Running qTox```bash

dnf install qtox

### From Build Directory```

```bash

./qtox<a name="gentoo-easy" />

```

#### Gentoo

### After Installation

```bashqTox is available in Gentoo.

qtox

```To install:



---```bash

emerge qtox

## Troubleshooting```



### Qt6 Not Found<a name="opensuse-easy" />



If CMake can't find Qt6:#### openSUSE



```bashqTox is available in openSUSE Factory.

# Check if Qt6 is installed

dpkg -l | grep qt6To install in openSUSE 15.0 or newer:



# Install Qt6 base packages```bash

sudo apt install qt6-base-devzypper in qtox

```

# Find Qt6 installation

find /usr -name "Qt6Config.cmake" 2>/dev/nullTo install in openSUSE 42.3:



# Set CMAKE_PREFIX_PATH if needed```bash

export CMAKE_PREFIX_PATH="/usr/lib/x86_64-linux-gnu/cmake/Qt6"zypper ar -f https://download.opensuse.org/repositories/server:/messaging/openSUSE_Leap_42.3 server:messaging

cmake ..zypper in qtox

``````



### toxcore Not Found<a name="slackware-easy" />



If toxcore is missing:#### Slackware



```bashqTox SlackBuild and all of its dependencies can be found here:

# Try installing from apthttp://slackbuilds.org/repository/14.2/network/qTox/

sudo apt install libtoxcore-dev

---

# Or build from source

git clone https://github.com/TokTok/c-toxcore.gitIf your distribution is not listed, or you want / need to compile qTox, there

cd c-toxcoreare provided instructions.

mkdir build && cd build

cmake ..---

make -j$(nproc)

sudo make installMost of the dependencies should be available through your package manager.

```

<a name="ubuntu-easy" />

### SQLCipher Not Found

#### Ubuntu

```bash

sudo apt install libsqlcipher-devqTox is available in the [Universe](https://packages.ubuntu.com/focal/qtox) repo, to install:

```

```bash

### FFmpeg Issuessudo apt install qtox

```

```bash

# Install all FFmpeg development libraries### Install git

sudo apt install \

    libavcodec-dev \In order to clone the qTox repository you need Git.

    libavdevice-dev \

    libavfilter-dev \<a name="arch-git" />

    libavformat-dev \

    libavutil-dev \#### Arch Linux

    libswscale-dev \

    libswresample-dev```bash

```sudo pacman -S --needed git

```

### OpenAL Not Found

<a name="debian-git" />

```bash

sudo apt install libopenal-dev#### Debian

```

```bash

### V4L2 (Camera) Issuessudo apt-get install git

```

```bash

# Install Video4Linux2 headers<a name="fedora-git" />

sudo apt install libv4l-dev

#### Fedora

# Check if camera works

v4l2-ctl --list-devices```bash

```sudo dnf install git

```

### X11 Development Headers Missing

<a name="opensuse-git" />

```bash

sudo apt install libx11-dev libxss-dev#### openSUSE

```

```bash

---sudo zypper install git

```

## Development Build

<a name="ubuntu-git" />

For development with debugging symbols:

#### Ubuntu

```bash

mkdir build-debug && cd build-debug```bash

cmake .. \sudo apt-get install git

    -DCMAKE_BUILD_TYPE=Debug \```

    -DUSE_CCACHE=ON \

    -DBUILD_TESTING=ON### Clone qTox

make -j$(nproc)

```Afterwards open a new terminal, change to a directory of your choice and clone

the repository:

---

```bash

## Building with Sanitizerscd /home/$USER

git clone https://github.com/qTox/qTox.git qTox

For memory/thread/UB debugging:cd qTox

```

```bash

# AddressSanitizer (memory errors)The following steps assumes that you cloned the repository at

cmake .. -DCMAKE_BUILD_TYPE=Debug -DASAN=ON`/home/$USER/qTox`. If you decided to choose another location, replace

make -j$(nproc)corresponding parts.



# ThreadSanitizer (thread issues)### Docker

cmake .. -DCMAKE_BUILD_TYPE=Debug -DTSAN=ON

make -j$(nproc)Development can be done within one of the many provided docker containers. See the available configurations in docker-compose.yml. These docker images have all the required dependencies for development already installed. Run `docker compose run --rm ubuntu_lts` and proceed to [compiling qTox](#compile-qtox). If you want to avoid compiling as root in the docker image, you can run `USER_ID=$(id -u) GROUP_ID=$(id -g) docker compose run --rm ubuntu_lts` instead.



# UndefinedBehaviorSanitizerNOTE: qtox will not run in the docker container unless your x11 session allows connections from other users. If X11 is giving you issues in the docker image, try `xhost +` on your host machine

cmake .. -DCMAKE_BUILD_TYPE=Debug -DUBSAN=ON

make -j$(nproc)<a name="other-deps" />

```

### GCC, Qt, FFmpeg, OpenAL Soft and qrencode

**Note:** Cannot use ASAN and TSAN together.

<a name="arch-other-deps" />

---

Please see https://github.com/TokTok/dockerfiles/tree/master/qtox/docker for your distribution for an up to date list of commands to set up your build environment

## Running Tests

### Compile dependencies

```bash

cd build<a name="compile-toxcore" />

cmake .. -DBUILD_TESTING=ON

make -j$(nproc)#### Compile toxcore

ctest --output-on-failure

```Provided that you have all required dependencies installed, you can simply run:



---```bash

git clone https://github.com/TokTok/c-toxcore.git toxcore

## Packagingcd toxcore

# Note: See https://github.com/TokTok/dockerfiles/blob/master/qtox/download/download_toxcore.sh

### Creating a Debian Package# for which version should be checked out.

cmake -B_build -H. -GNinja -DBOOTSTRAP_DAEMON=OFF

```bashcmake --build _build

cd buildsudo cmake --install _build

cpack -G DEB

```# we don't know what whether user runs 64 or 32 bits, and on some distros

# (Fedora, openSUSE) lib/ doesn't link to lib64/, so add both

This creates a `.deb` package you can install with:echo '/usr/local/lib64/' | sudo tee -a /etc/ld.so.conf.d/locallib.conf

```bashecho '/usr/local/lib/' | sudo tee -a /etc/ld.so.conf.d/locallib.conf

sudo dpkg -i qtox-*.debsudo ldconfig

``````



### Flatpak### Compile qTox



See `platform/flatpak/` for Flatpak packaging instructions.**Make sure that all the dependencies are installed.** If you experience

problems with compiling, it's most likely due to missing dependencies, so please

---make sure that you did install _all of them_.



## UninstallingIf you are compiling on Fedora 25, you must add libtoxcore to the

`PKG_CONFIG_PATH` environment variable manually:

```bash

# If installed via make install```

cd build# we don't know what whether user runs 64 or 32 bits, and on some distros

sudo make uninstall# (Fedora, openSUSE) lib/ doesn't link to lib64/, so add both

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib64/pkgconfig"

# If installed via .deb packageexport PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig"

sudo apt remove qtox```

```

Run in qTox directory to compile:

---

```bash

## Getting Helpcmake -B_build -H.

cmake --build _build

- **Build Issues**: Check error messages and ensure all dependencies are installed```

- **Runtime Issues**: Run with debug output: `QT_LOGGING_RULES="*.debug=true" qtox`

- **Bug Reports**: https://github.com/p19racha/qTox/issuesNow you can start compiled qTox with `_build/qtox`



---Congratulations, you've compiled qTox `:)`



## Ubuntu Version Compatibility#### Debian / Ubuntu / Mint



| Ubuntu Version | Supported | Notes |If the compiling process stops with a missing dependency like:

|----------------|-----------|-------|`... libswscale/swscale.h missing` try:

| 24.04 LTS      | ✅ Yes    | Recommended, Qt 6.6+ |

| 23.10          | ✅ Yes    | Qt 6.5+ |```bash

| 23.04          | ✅ Yes    | Qt 6.4+ |apt-file search libswscale/swscale.h

| 22.04 LTS      | ✅ Yes    | Minimum required, Qt 6.2+ |```

| 20.04 LTS      | ⚠️ Maybe  | Requires Qt6 PPA or manual build |

| 18.04 LTS      | ❌ No     | Too old, Qt5 only |And install the package that provides the missing file.

Start make again. Repeat if necessary until all dependencies are installed. If

---you can, please note down all additional dependencies you had to install that

aren't listed here, and let us know what is missing `;)`

## Performance Tips

---

1. **Use ccache**: Speeds up recompilation

   ```bash### Security hardening with AppArmor

   sudo apt install ccache

   cmake .. -DUSE_CCACHE=ONSee [AppArmor] to enable confinement for increased security.

   ```

## BSD

2. **Release builds**: Much faster than Debug

   ```bash<a name="freebsd-easy" />

   cmake .. -DCMAKE_BUILD_TYPE=Release

   ```#### FreeBSD



3. **Parallel compilation**: Use all CPU coresqTox is available as a binary package. To install the qTox package:

   ```bash

   make -j$(nproc)```bash

   ```pkg install qTox

```

4. **Link Time Optimization** (advanced):

   ```bashThe qTox port is also available at `net-im/qTox`. To build and install qTox

   cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ONfrom sources using the port:

   ```

```bash

---cd /usr/ports/net-im/qTox

make install clean

## System Integration```



### Desktop Entry<a name="macos" />



The installation creates a desktop entry automatically. To manually install:## macOS



```bashSupported macOS versions: >=10.15.

sudo cp res/qtox.desktop /usr/share/applications/

sudo update-desktop-databaseCompiling qTox on macOS for development requires 2 tools:

```[Xcode](https://developer.apple.com/xcode/) and [homebrew](https://brew.sh).



### Icons### Manual Compiling



```bash#### Required Libraries

sudo cp img/icons/qtox.svg /usr/share/icons/hicolor/scalable/apps/

sudo gtk-update-icon-cache /usr/share/icons/hicolor/Install homebrew if you don't have it:

```

```bash

---ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

```

## Next Steps

First, clone qTox.

After successful build:

- Launch qTox and create your Tox profile```bash

- Configure audio/video settingsgit clone https://github.com/qTox/qTox

- Add friends via Tox IDcd qTox

- Enjoy secure, private messaging!```



For usage instructions, see the [User Manual](doc/user_manual_en.md).Then install required dependencies available via `brew`.



---```bash

brew bundle --file platform/macos/Brewfile

## Migration from qTox 1.x```



If you're upgrading from the multi-platform qTox 1.x:Then, install [toxcore](https://github.com/TokTok/c-toxcore/blob/master/INSTALL.md).



1. **Profile Compatibility**: Your existing Tox profile should work```bash

2. **Settings**: Settings will be migrated automaticallygit clone --depth=1 https://github.com/TokTok/dockerfiles

3. **Data Location**: `~/.config/tox/` (unchanged)dockerfiles/qtox/build_toxcore_system.sh

4. **History**: Chat history is preserved```



---Finally, build qTox.



## Why Ubuntu-Only?#### Compiling



Version 2.0 focuses exclusively on Ubuntu to:```bash

- Reduce code complexitycmake -B_build -H. -GNinja -DCMAKE_PREFIX_PATH=$(brew --prefix qt@6)

- Improve build timescmake --build _build

- Enable modern UI developmentcmake --install _build

- Provide better Ubuntu integration```

- Simplify testing and support

#### Running qTox

For Windows/macOS support, use the original [qTox 1.x](https://github.com/TokTok/qTox).

`qTox.dmg` should be in your `_build` directory. You can install qTox from the dmg
to your Applications folder, or run qTox directly from the dmg.

<a name="windows" />

## Windows

Only cross-compiling from Linux is supported and tested in CI, but building
under MSYS should also work.

### Cross-compile from Linux

See [`platform/windows/cross-compile`](platform/windows/cross-compile).

## Compile-time switches

They are passed as an argument to `cmake` command. E.g. with a switch `SWITCH`
that has value `ON` it would be passed to `cmake` in a following manner:

```bash
cmake -DSWITCH=ON
```

Look at the beginning of `CMakeLists.txt` for a list of options. Options that
are `ON` by default can be turned off by passing `-DSWITCH=OFF`.

[AppArmor]: /security/apparmor/README.md
[Atk]: https://wiki.gnome.org/Accessibility
[Cairo]: https://www.cairographics.org/
[Check]: https://libcheck.github.io/check/
[CMake]: https://cmake.org/
[DBus Menu]: https://launchpad.net/libdbusmenu
[FFmpeg]: https://www.ffmpeg.org/
[GCC]: https://gcc.gnu.org/
[libX11]: https://www.x.org/wiki/
[libXScrnSaver]: https://www.x.org/wiki/Releases/ModuleVersions/
[MinGW]: http://www.mingw.org/
[OpenAL Soft]: http://kcat.strangesoft.net/openal.html
[Pango]: http://www.pango.org/
[pkg-config]: https://www.freedesktop.org/wiki/Software/pkg-config/
[qrencode]: https://fukuchi.org/works/qrencode/
[Qt]: https://www.qt.io/
[toxcore]: https://github.com/TokTok/c-toxcore/
[sonnet]: https://github.com/KDE/sonnet
[libnotify]: https://gitlab.gnome.org/GNOME/libnotify
[sqlcipher]: https://github.com/sqlcipher/sqlcipher
