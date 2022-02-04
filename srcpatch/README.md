# SrcPatch

This sub-project reconstructs a missing file, `XLIB.PAS` which is needed
in order to build XQuest2 with a compiler other than Turbo Pascal 6. Additional
changes to the source files allows compilation with a
[Free Pascal Compiler](https://www.freepascal.org/) cross-compiler on Linux.

The source files are updated by applying a patch. Once the patch has been
applied, the XQUEST.EXE executable can be built on DOS (with Turbo Pascal 6 or
7) or on Linux (with a Free Pascal Compiler cross-compiler).

### Patch XQuest2 source files

    $ ./apply-patch.sh      Extract XQuest2 sources to  `./build/xq2` and apply a patch

Once the patch has been applied:

### If on DOS/DOSBox/FreeDOS/DosEmu (and building with Turbo Pascal 6 or 7):

    1) Copy the `./build/xq2` directory to your DOS environment
    2) Copy `build-xq.bat` to your DOS environment
    3) Ensure the Turbo Pascal 6 or 7 compiler (TPC.EXE) is in your PATH.
    4) In your DOS environment, run `build-xq.bat`.

`build-xq.bat` is a simple .BAT file. You may prefer to exclude it and
manually run the compile command contained in it.

### If on Linux (and cross-compiling with FPC):

    $ ./build-xq.sh      Downloads an FPC cross-compiler and builds XQUEST.EXE

When the build has completed, copy `./build/xq2` to your DOS environment and run `xquest.exe`.

I am not the author of XQuest2, I am just a fan of the game and didn't want to see it disappear.
