#!/bin/sh
# Copyright (C) 2016 Michel Gutierrez
# This file is license under GPL 2.0

BASEDIR=$(dirname $(readlink -e "$0"))
BASEDIRWIN=$(echo "$BASEDIR" | sed -e 's/\//\\\\/g')
TMPDIR="$BASEDIR/tmp"
TMPDIRWIN=$(echo "$TMPDIR" | sed -e 's/\//\\\\/g')
BUILDDIR="$BASEDIR/build"
BUILDDIRWIN=$(echo "$BUILDDIR" | sed -e 's/\//\\\\/g')
DISTDIR="$BASEDIR/dist"
DISTDIRWIN=$(echo "$DISTDIR" | sed -e 's/\//\\\\/g')
SRCDIR="$BASEDIR/src"

VERSION=$(cat "$BASEDIR/VERSION")
PRODUCT=$(cat "$BASEDIR/PRODUCT")
BUILDER=$(cat "$BASEDIR/BUILDER")
BUILDER_WEBSITE=$(cat "$BASEDIR/BUILDER_WEBSITE")

echo "TMPDIR $TMPDIR $TMPDIRWIN"
echo "BUILDDIR $BUILDDIR $BUILDDIRWIN"
echo "DISTDIR $DISTDIR $DISTDIRWIN"

rm -rf TMPDIR
mkdir -p "$TMPDIR"
rm -rf DISTDIR
mkdir -p "$DISTDIR"

resolve() {
	FILE="$1"
	cat "$BASEDIR/$FILE" | \
		sed -e "s/{{VERSION}}/$VERSION/g" |\
		sed -e "s/{{PRODUCT}}/$PRODUCT/g" |\
		sed -e "s/{{BUILDER}}/$BUILDER/g" |\
		sed -e "s#{{BUILDER_WEBSITE}}#$BUILDER_WEBSITE#g" |\
		sed -e "s/{{TMPDIR}}/$TMPDIRWIN/g" |\
		sed -e "s/{{BUILDDIR}}/$BUILDDIRWIN/g" |\
		sed -e "s/{{DISTDIR}}/$DISTDIRWIN/g" |\
		sed -e "s/{{BASEDIR}}/$BASEDIRWIN/g" |\
		sed -e "s/\r*$/\r/g" > "$TMPDIR/$FILE"
} 

resolve libav-xbuild2win.iss
resolve info-post.txt
resolve README.txt

echo "Executing $TMPDIRWIN\\\\libav-xbuild2win.iss"
(wine ~/.wine/drive_c/Program\ Files/Inno\ Setup\ 5/ISCC.exe "tmp\\\\libav-xbuild2win.iss")

