#!/bin/sh
set -e

rm -rf ./build/xq2

mkdir -p ./build/xq2
cd ./build/xq2
    tar -xzf ../../support/xquest_1.3_src.tar.gz
    patch -i ../../support/xquest13.patch
    rm -rf ./distrib
    rm -f *.tpu
cd ../..

echo ""
echo "XQuest2 source files have been patched."
echo ""
echo "  * If building with Free Pascal Compiler, run './build-xq.sh'."
echo ""
echo "  * If building with Turbo Pascal 6 or 7, copy './build/xq2' and"
echo "    'build-xq.bat' to your DOS environment and run 'build-xq.bat'."
