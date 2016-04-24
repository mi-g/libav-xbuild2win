#!/bin/bash
# Copyright (C) 2016 Michel Gutierrez
# This file is license under GPL 2.0

BASEDIR=$(dirname $(readlink -e "$0"))
BUILDDIR="$BASEDIR/build"
SRCDIR="$BASEDIR/src-build"
SRCCLEANDIR="$BASEDIR/src"

build_lame() {
	(
	echo "Building lame"
	cd $ARCHSRCDIR/lame
	if [ "$ARCH" == "i686" ]; then
	    export CFLAGS="-msse"
	fi
	./configure --prefix=$ARCHSRCDIR/libav-deps --host=$HOST --target=mingw32 || exit -1
	export CFLAGS=
	make || exit -1
	make install || exit -1
	)
}

build_ogg() {
	(
	echo "Building ogg"
	cd $ARCHSRCDIR/ogg
	./autogen.sh
	./configure --prefix=$ARCHSRCDIR/libav-deps --host=$HOST --target=mingw32 || exit -1
	make || exit -1
	make install || exit -1
	)
}

build_vorbis() {
	(
	echo "Building vorbis"
	cd $ARCHSRCDIR/vorbis
	./autogen.sh || exit -1
	export CFLAGS="-I$ARCHSRCDIR/libav-deps/include"
	./configure --prefix=$ARCHSRCDIR/libav-deps --host=$HOST --target=mingw32 || exit -1
	export CFLAGS=
	make || exit -1
	make install || exit -1
	)
}

build_opus() {
	(
	echo "Building opus"
	cd $ARCHSRCDIR/opus
	./autogen.sh || exit -1
	./configure --prefix=$ARCHSRCDIR/libav-deps --host=$HOST --target=mingw32 || exit -1
	make || exit -1
	make install-am || exit -1
	)
}

build_vpx() {
	(
	echo "Building vpx"
	cd $ARCHSRCDIR/vpx
	TARGET="x86_64-win64-gcc"
	if [ "$ARCH" == "i686" ]; then
		TARGET="x86-win32-gcc"
	fi
	./configure --prefix=$ARCHSRCDIR/libav-deps --target=$TARGET \
        --disable-examples \
        --disable-docs \
        --disable-install-bins \
        --disable-install-srcs \
        --size-limit=16384x16384 \
        --enable-postproc \
        --enable-multi-res-encoding \
        --enable-temporal-denoising \
        --enable-vp9-temporal-denoising \
        --enable-vp9-postproc || exit -1
	TARGET=
	make || exit -1
	make install || exit -1
	)
}

build_x264() {
	(
	echo "Building x264"
	cd $ARCHSRCDIR/x264
	./configure --host=$ARCH-w64-mingw32 --cross-prefix=$ARCH-w64-mingw32- \
    --prefix=$ARCHSRCDIR/libav-deps --enable-shared --sysroot=/usr/$ARCH-w64-mingw32/ || exit -1
	make || exit -1
	make install install-lib-dev install-lib-shared install-lib-static || exit -1
	)
}

build_xvid() {
	(
	echo "Building xvid"
	cd $ARCHSRCDIR/xvid/build/generic
	./bootstrap.sh
	./configure --host=$ARCH-w64-mingw32 --target=mingw32 --prefix=$ARCHSRCDIR/libav-deps --disable-assembly || exit -1
	make || exit -1
	make install || exit -1
	)
}

build_ocamr() {
	(
	echo "Building ocamr (Opencore AMR)"
	cd $ARCHSRCDIR/ocamr
	libtoolize
	aclocal
	autoheader
	automake --force-missing --add-missing
	autoconf
	./configure --host=$ARCH-w64-mingw32 --target=mingw32 --prefix=$ARCHSRCDIR/libav-deps || exit -1
	make || exit -1
	make install || exit -1
	)
}

build_voaacenc() {
	(
	echo "Building voaacenc (Opencore Visual On AAC encoder)"
	cd $ARCHSRCDIR/voaacenc
	libtoolize
	aclocal
	autoheader
	automake --force-missing --add-missing
	autoconf
	./configure --host=$ARCH-w64-mingw32 --target=mingw32 --prefix=$ARCHSRCDIR/libav-deps || exit -1
	make || exit -1
	make install || exit -1
	)
}

build_voamrwbenc() {
	(
	echo "Building voamrwbenc (Opencore Visual On AMR WB encoder)"
	cd $ARCHSRCDIR/voamrwbenc
	libtoolize
	aclocal
	autoheader
	automake --force-missing --add-missing
	autoconf
	./configure --host=$ARCH-w64-mingw32 --target=mingw32 --prefix=$ARCHSRCDIR/libav-deps || exit -1
	make || exit -1
	make install || exit -1
	)
}

build_sdl() {
	(
	echo "Building sdl"
	cd $ARCHSRCDIR/sdl
	rm -r autom4te.cache configure config.h config.h.i config.status config.mak Makefile libtool ltmain.sh
	./autogen.sh || exit -1
	./configure --host=$ARCH-w64-mingw32 --target=mingw32 --prefix=$ARCHSRCDIR/libav-deps || exit -1
	make || exit -1
	make install || exit -1
	)
}

build_webp() {
	(
	echo "Building webp"
	cd $ARCHSRCDIR/webp
	libtoolize
	aclocal
	autoheader
	automake --force-missing --add-missing
	autoconf
	./configure --host=$ARCH-w64-mingw32 --target=mingw32 --prefix=$ARCHSRCDIR/libav-deps \
    --enable-libwebpmux --enable-libwebpdemux  --enable-libwebpdecoder|| exit -1
	make || exit -1
	make install || exit -1
	)
}

build_zlib() {
	(
	echo "Building zlib"
	cd $ARCHSRCDIR/zlib
    sed -i "s/PREFIX =/PREFIX = $ARCH-w64-mingw32-/" win32/Makefile.gcc
    make \
        INCLUDE_PATH="/include" \
        LIBRARY_PATH="/lib" \
        BINARY_PATH="/bin" \
        DESTDIR="$ARCHSRCDIR/libav-deps" install \
        -f win32/Makefile.gcc SHARED_MODE=1 || exit -1
	)
}

build_jpeg() {
	(
	echo "Building jpeg"
	cd $ARCHSRCDIR/jpeg
	cmake -DCMAKE_SYSTEM_NAME=Windows -DBUILD_THIRDPARTY=1 \
        -DCMAKE_INSTALL_PREFIX="$ARCHSRCDIR/libav-deps" \
        -DOPENJPEG_INSTALL_INCLUDE_DIR="$ARCHSRCDIR/libav-deps/include" \
        -DOPENJPEG_INSTALL_LIB_DIR="$ARCHSRCDIR/libav-deps/lib" \
        -DOPENJPEG_INSTALL_DOC_DIR="$ARCHSRCDIR/libav-deps/doc" \
        -DOPENJPEG_INSTALL_BIN_DIR="$ARCHSRCDIR/libav-deps/bin" \
        -DOPENJPEG_INSTALL_DATA_DIR="$ARCHSRCDIR/libav-deps/data" \
        -DOPENJPEG_INSTALL_SHARE_DIR="$ARCHSRCDIR/libav-deps/share" \
        . || exit -1
    make install
	)
}

build_x265() {
	(
	echo "Building x265"
	cd $ARCHSRCDIR/x265
    cmake \
        -DWINXP_SUPPORT=1 \
        -DCMAKE_INSTALL_PREFIX="$ARCHSRCDIR/libav-deps" \
        -DCMAKE_SYSTEM_NAME="Windows" \
        -DCMAKE_C_COMPILER="$ARCH-w64-mingw32-gcc" \
        -DCMAKE_CXX_COMPILER="$ARCH-w64-mingw32-g++" \
        -DCMAKE_RC_COMPILER="$ARCH-w64-mingw32-windres" \
        -DCMAKE_RANLIB="$ARCH-w64-mingw32-ranlib" \
        -DCMAKE_ASM_YASM_COMPILER="yasm" \
        source
    make x265-shared
    cp libx265.dll.a "$ARCHSRCDIR/libav-deps/lib"
    cp libx265.dll "$ARCHSRCDIR/libav-deps/bin"
    cp source/x265.h "$ARCHSRCDIR/libav-deps/include"
    cp x265_config.h "$ARCHSRCDIR/libav-deps/include"
    cp x265.pc "$ARCHSRCDIR/libav-deps/lib/pkgconfig"
	)
}

build_orc() {
	(
	echo "Building orc"
	cd $ARCHSRCDIR/orc
	./autogen.sh
	if [ "$ARCH" == "i686" ]; then
	    export LDFLAGS="-L$GCC_LIBDIR -L/usr/$ARCH-w64-mingw32/lib -L$ARCHSRCDIR/libav-deps/lib"
        export CFLAGS="-I$ARCHSRCDIR/libav-deps/include/orc-0.4"
	fi
	./configure --host=$ARCH-w64-mingw32 --prefix=$ARCHSRCDIR/libav-deps \
    --enable-shared --enable-static \
    || exit -1
	make || exit -1
	make install
    export LDFLAGS=
	export CFLAGS=
	)
}

build_schro() {
	(
	echo "Building schro"
	cd $ARCHSRCDIR/schro
	./autogen.sh
	if [ "$ARCH" == "i686" ]; then
	    export LDFLAGS="-L$GCC_LIBDIR -L/usr/$ARCH-w64-mingw32/lib"
        export PATH_OLD=$PATH
        export PATH="$PATH:$GCC_LIBDIR"
	fi
	./configure --host=$ARCH-w64-mingw32 --build=mingw32 --prefix=$ARCHSRCDIR/libav-deps \
    --enable-shared --disable-static --disable-testsuite \
    || exit -1
    sed -i "s/testsuite//" Makefile
    make || exit -1
	make install
	if [ "$ARCH" == "i686" ]; then
        export LDFLAGS=
        export PATH=$PATH_OLD
    fi
	)
}

build_theora() {
	(
	echo "Building theora"
	cd $ARCHSRCDIR/theora
	libtoolize
	aclocal
	autoheader
	automake --force-missing --add-missing
	autoconf
	./configure --host=$ARCH-w64-mingw32 --prefix=$ARCHSRCDIR/libav-deps \
    --disable-examples --without-vorbis --disable-oggtest \
    || exit -1
    sed -i -e 's#\r##g' win32/xmingw32/libtheoradec-all.def
    sed -i -e 's#\r##g' win32/xmingw32/libtheoraenc-all.def
	make || exit -1
	make install || exit -1
	)
}

build_ssl() {
	(
	echo "Building ssl"
	cd $ARCHSRCDIR/ssl
    CROSS_COMPILE_BAK="$CROSS_COMPILE"
    export CROSS_COMPILE="$CROSS_COMPILE"
    CC_BAK="$CC"
    export CC="gcc"
    ./Configure shared no-asm no-dso zlib-dynamic no-gost \
    --prefix=$ARCHSRCDIR/libav-deps mingw64 \
    -L"$ARCHSRCDIR/libav-deps/lib" -I"$ARCHSRCDIR/libav-deps/include"
    make || exit -1
    (
        cd engines;
        touch lib4758cca.bad libaep.bad libatalla.bad libcswift.bad libchil.bad libgmp.bad \
        libnuron.bad libsureware.bad libubsec.bad libcapi.bad libpadlock.bad
    )
	make install_sw install || exit -1
    export CROSS_COMPILE=
    export CC="$CC_BAK"
    CROSS_COMPILE="$CROSS_COMPILE_BAK"
	)
}

build_rtmp() {
	(
	echo "Building rtmp"
	cd $ARCHSRCDIR/rtmp/librtmp
    sed -i "s/prefix=.*/prefix=..\/..\/libav-deps/" Makefile
    XLDFLAGS="-L$ARCHSRCDIR/libav-deps/lib -shared -Wl,--out-implib,librtmp.dll.a" \
    SHARED=yes \
    make install \
    SYS=mingw CROSS_COMPILE=$ARCH-w64-mingw32- INC="-I$ARCHSRCDIR/libav-deps/include" \
    LIB="-L$ARCHSRCDIR/libav-deps/lib"
	)
}

build_libav() {
	(
	echo "Building libav"
	cd $ARCHSRCDIR/libav
    sed -i "s/#define.*OPJ_STATIC//" libavcodec/libopenjpegenc.c
    sed -i "s/#define.*OPJ_STATIC//" libavcodec/libopenjpegdec.c
    sed -i "s/-DOPJ_STATIC//" configure
	./configure \
        --cross-prefix=$ARCH-w64-mingw32- \
        --arch=$ARCH \
        --sysroot=/usr/$ARCH-w64-mingw32/ \
		--extra-ldflags=-static-libgcc \
        --target-os=mingw32 \
        --enable-memalign-hack \
        --enable-runtime-cpudetect \
        --enable-cross-compile \
        --enable-gpl \
        --enable-shared \
		--enable-pthreads \
        --prefix=$BUILDARCHDIR \
        --enable-version3 \
		--extra-cflags="-I$ARCHSRCDIR/libav-deps/include" \
        --extra-ldflags="-L$ARCHSRCDIR/libav-deps/lib" \
        --pkg-config=$PKG_CONFIG \
        --enable-libvo-aacenc \
        --enable-libvo-amrwbenc \
        --enable-libopus \
        --enable-libvorbis \
		--enable-libx264 \
        --enable-libmp3lame \
        --enable-libvpx \
        --enable-libxvid \
        --enable-libopencore_amrnb \
        --enable-libopencore_amrwb \
        --enable-encoder=libvpx-vp9 \
        --enable-libwebp \
        --enable-zlib \
        --enable-libopenjpeg \
        --enable-libx265 \
        --enable-libschroedinger \
        --enable-libtheora \
        --enable-librtmp \
        || exit -1
	make || exit -1
	make install || exit -1
	)
}

build_arch() {
	ARCH="$1"
	FINALARCHDIR="$2"
	ARCHSRCDIR="$3"
	BUILDARCHDIR="$ARCHSRCDIR/libav-build"
	HOST="$ARCH-w64-mingw32"

	echo "Build for $ARCH to $BUILDARCHDIR via $ARCHSRCDIR"

	CROSS_COMPILE="/usr/bin/${ARCH}-w64-mingw32-"
	export CC="${CROSS_COMPILE}gcc"
	export CXX="${CROSS_COMPILE}g++"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LD="${CROSS_COMPILE}ld"
	export PKG_CONFIG="${CROSS_COMPILE}pkg-config"
	export PKG_CONFIG_PATH=$ARCHSRCDIR/libav-deps/lib/pkgconfig
	export PKG_CONFIG_LIBDIR=$ARCHSRCDIR/libav-deps/lib/pkgconfig
	export GCC_LIBDIR=$(ls -d /usr/lib/gcc/$ARCH-w64-mingw32/*-posix)

	echo "ARCH=\"$1\""
	echo "FINALARCHDIR=\"$2\""
	echo "ARCHSRCDIR=\"$3\""
	echo 'BUILDARCHDIR="$ARCHSRCDIR/libav-build"'
	echo 'HOST="$ARCH-w64-mingw32"'
	echo 'CROSS_COMPILE="/usr/bin/${ARCH}-w64-mingw32-"'
	echo 'export CC="${CROSS_COMPILE}gcc"'
	echo 'export CXX="${CROSS_COMPILE}g++"'
	echo 'export NM="${CROSS_COMPILE}nm"'
	echo 'export STRIP="${CROSS_COMPILE}strip"'
	echo 'export RANLIB="${CROSS_COMPILE}ranlib"'
	echo 'export AR="${CROSS_COMPILE}ar"'
	echo 'export LD="${CROSS_COMPILE}ld"'
	echo 'export PKG_CONFIG="${CROSS_COMPILE}pkg-config"'
	echo 'export PKG_CONFIG_PATH=$ARCHSRCDIR/libav-deps/lib/pkgconfig'
	echo "export GCC_LIBDIR=\"$GCC_LIBDIR\""

	build_lame || exit -1
	build_ogg || exit -1
	build_vorbis || exit -1
	build_opus || exit -1
	build_vpx || exit -1
	build_x264 || exit -1
	build_xvid || exit -1
	build_ocamr || exit -1
	build_voaacenc || exit -1
	build_voamrwbenc || exit -1
	build_sdl || exit -1
	build_webp || exit -1
	build_zlib || exit -1
    build_jpeg || exit -1
    build_x265 || exit -1
    build_orc || exit -1
    build_schro || exit -1
    build_theora || exit -1
    build_ssl || exit -1
    build_rtmp || exit -1
	build_libav || exit -1

	export CROSS_COMPILE=
	export CC=
	export CXX=
	export NM=
	export STRIP=
	export RANLIB=
	export AR=
	export LD=
	export PKG_CONFIG="${CROSS_COMPILE}pkg-config"
	export PKG_CONFIG_PATH=
	export PKG_CONFIG_LIBDIR=

	cp $BUILDARCHDIR/bin/avconv.exe $BUILDARCHDIR/bin/avprobe.exe $BUILDARCHDIR/bin/avplay.exe $BUILDARCHDIR/bin/*.dll $FINALARCHDIR
    cp /usr/$ARCH-w64-mingw32/lib/libwinpthread-1.dll $FINALARCHDIR
    cp $GCC_LIBDIR/libstdc++-6.dll $FINALARCHDIR
    if [ "$ARCH" == "i686" ]; then
        cp $GCC_LIBDIR/libgcc_s_sjlj-1.dll $FINALARCHDIR
	fi
    if [ "$ARCH" == "x86_64" ]; then
        cp $GCC_LIBDIR/libgcc_s_seh-1.dll $FINALARCHDIR
	fi
	cp $(find "$ARCHSRCDIR/libav-deps" -name "*.dll") $FINALARCHDIR

	export GCC_LIBDIR=
}

rm -rf $BUILDDIR
rm -rf $SRCDIR

mkdir -p "$SRCDIR/32" "$SRCDIR/64"
cp -r $SRCCLEANDIR/* "$SRCDIR/64"
mkdir -p "$SRCDIR/64/libav-deps"
cp -r $SRCCLEANDIR/* "$SRCDIR/32"
mkdir -p "$SRCDIR/32/libav-deps"
mkdir -p "$SRCDIR/32/libav-build"

mkdir -p "$BUILDDIR/32" "$BUILDDIR/64"

build_arch x86_64 $BUILDDIR/64 $SRCDIR/64 || exit -1
build_arch i686 $BUILDDIR/32 $SRCDIR/32 || exit -1


