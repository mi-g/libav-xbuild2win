libav-xbuild2win
================

This set of scripts allows to generate, from scratch and on Linux, the binary of a setup EXE file to install [Libav](http://libav.org/) (GPL version) easily on Windows.

The generator has been developed and tested on Ubuntu 15.10 and Ubuntu 16.04.

The Libav application and associated libraries are generated in both 32 and 64 bits versions. The generated unique setup file takes care of installing the
appropriate version depending on the platform. It has been tested on both Windows 32 bits and Windows 10.

In addition to Libav core code, the included libraries are:
- libmp3lame
- libogg
- libvorbis
- libopus
- libvpx
- libx264
- libx265
- libxvidcore
- OpenCore amr
- VisualOn aac enc
- VisualOn amrwb enc
- libSDL
- libwebp
- libz
- libopenjpeg
- liborc
- libschroedinger
- libtheora
- openssl
- librtmp

get-sources.sh
--------------

This script connects to various git servers to clone the approriate repository and checkout the code versions. 

You must have `git` installed on your linux computer:
```
sudo apt-get install git
```
To invoke the script, just type:
```
./get-sources.sh
```
You will end up with a `src` sub-directory containing all the necessary source code.

build-apps.sh
-------------

This script compiles previously downloaded the source code from `src` to generate both 32 and 64 bits versions of 
libav and associated library DLLs.

You must have a number of Ubuntu packages installed in order to run the script:
```
sudo apt-get install git build-essential mingw-w64 mingw-w64-tools autoconf libtool-bin yasm cmake
```
To invoke the build script, just type:
```
./build-apps
```
Go and grab a few coffees since this script takes a while to run.

You will end up with a `build` subdirectory containing `32/` and `64/` with all the necessary files to run Libav on either architecture.

make-dist.sh
------------

This script generates a .EXE file that you must execute to setup the Libav application on a Windows machine.

In order to generate the installer, the script makes use of Inno5, available from
[http://www.jrsoftware.org/isinfo.php](http://www.jrsoftware.org/isinfo.php) and invokes it through `wine`. So you need to
have `wine` installed on the Linux host:
```
sudo apt-get install wine
```
The Inno 5 program is expected to be installed at location
 `~/.wine/drive_c/Program\ Files/Inno\ Setup\ 5/ISCC.exe`. To install it, download the file [`is.exe`](http://www.jrsoftware.org/download.php/is.exe) 
 and execute it with `wine`:
 ```
 wine is.exe
 ```
 
You will end up with a `dist` directory containing the installer EXE file.

To customize the final application, edit files:
- PRODUCT
- VERSION
- BUILDER
- BUILDER_WEBSITE

Licensing
---------

This set of scripts are licensed under the Gnu Public License 2.0.

For information, the program files resulting from the execution of the scripts will be covered  by the Gnu Public License.
