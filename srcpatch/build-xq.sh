#!/bin/sh
# This script will build the XQUEST.EXE DOS executable on Linux.
#
# An FPC cross-compiler will be downloaded, if not present.
#
# If you wish to use an updated cross-compiler:
#   1) Update the FPC_XZ variable
#   2) Update the '-Fu<x>' path (supplied to 'ppcross8086') to reflect updated path.

set -e

# FPC Linux cross-compiler which generates DOS 80286 code.
FPC_XZ=fpc-3.2.2.x86_64-linux.cross.i8086-msdos.tar.xz




# Ensure source files exist.
if [ ! -e ./build/xq2 ]; then
    echo "Error: The XQuest2 source files do not exist."
    echo "Run './apply-patch.sh' to extract the XQuest2 source files and apply patches."
    exit 1
fi




# Download FPC cross-compiler.
if [ ! -e ./support/$FPC_XZ ]; then
    cd ./support
        echo "Downloading ${FPC_XZ} (160 Mb)..."
        wget --quiet --show-progress https://sourceforge.net/projects/freepascal/files/Linux/3.2.2/${FPC_XZ}/download -O ${FPC_XZ}

    cd ..
fi




# Extract FPC cross-compiler.
if [ ! -e ./build/cross ]; then
    mkdir -p ./build/cross
    cd ./build/cross
        echo ""
        echo "Extracting ${FPC_XZ}..."
        tar -xJf ../../support/${FPC_XZ} .
    cd ../..
fi




# Build XQUEST.EXE with FPC cross-compiler.
cd ./build/xq2
    echo "Building..."

    # -B        Build all modules
    # -Cp80286  Generate 80286 instructions
    # -WmLarge  Use Large memory model
    # -Rintel   Read Intel-style assembler
    # -Mtp      Turbo Pascal compatibility mode
    # -Fu<x>    Add <x> to unit path
    # -vwhilq   (Optional) Be verbose. Show (w)arning, (h)ints, (i)nfo, (l)inenumbers, (q)message numbers

    CURDIR=`pwd`
    ./../cross/bin/ppcross8086 -B -Cp80286 -WmLarge -Rintel -Mtp "-Fu${CURDIR}/../cross/lib/fpc/3.2.2/units/msdos/80286-large/*" xquest.pas

    rm -f *.a
    rm -f *.ppu
    echo ""
    echo "Done building. Copy './build/xq2' to your DOS environment and run XQUEST.EXE."
cd ..
