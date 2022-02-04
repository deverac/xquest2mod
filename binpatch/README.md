# BinPatch

This sub-project patches the [XQuest2](http://www.swallowtail.org/xquest/)
binary to enable Power Ups, and more.

XQuest2 is a (better!) clone of Macintosh's Crystal Quest. You may also be
interested in [xquestjs](https://github.com/scottrippey/xquestjs) which is
an XQuest clone made with HTML5 and Javascript.

xquest2mod help screen:

    Patch XQUEST2 to modify its behavior.
    Usage: XQ.BAT [OPTIONS]
    OPTIONS is one or more of the following:
     /?, /h, /help  Show this text and exit
     /bombs N       Number of smart bombs (Max: 999)
     /level N       Starting level (Max: 50)
     /lives N       Number of lives (Max: 999)
     /nodie         Never die
     /skipintro     Skip intro title screens
     /run [ARGS]    Run patched version; [ARGS] will be passed to XQUEST2
     /reset         Overwrite patched copy with original
     /aimedfire  M
     /bouncefire M
     /heavyfire  M                 ___Power Ups___
     /multifire  M      Max value of Power Ups is 65535 (0xFFFF)
     /rapidfire  M      which provides about 15 minutes of use.
     /rearfire   M
     /shields    M


Examples:

    xq.bat /bombs 83         Patch XQUEST2 to start with 83 smart bombs
    xq.bat /lives 27         Patch XQUEST2 to start with 27 lives
    xq.bat /shields 800      Patch XQUEST2 to start with shields at 800

    xq.bat /run -nosound     Run the patched version of XQUEST2, passing it
                             the '-nosound' parameter.

The above can also be accomplished with:

    xq.bat /bombs 83 /lives 27 /shields 800 /run -nosound


Once a patch is applied, the modification is persistent (i.e. no need to
re-apply the patch).

To 'undo' all previous patches:

    xq.bat /reset



`xq.bat` should run under any DOS-like system
(e.g. [FreeDOS](https://www.freedos.org), [DOSBox](https://www.dosbox.com/)).
The first time `xq.bat` is run, it will unzip and then delete
`.\work\xquest2.zip`; the `.\work\unzip.exe` file will also be deleted. The `.\work\bc.exe` file is from FreeDOS and can be deleted if `xq.bat` is run on
FreeDOS because FreeDOS provides its own copy. The `.\work\unzip.exe` file was
built from
[Info-zip sources](https://sourceforge.net/projects/infozip/files/UnZip%206.x%20%28latest%29/UnZip%206.0/)
to avoid having to depend on CWSDPMI.EXE (which FreeDOS's `unzip.exe` requires).

Although this program is free software, the `xquest2.zip` file is not free
software. The XQUEST2 license permits distribution.
