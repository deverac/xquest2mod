@echo off
rem This batch file will apply binary patches to XQUEST.EXE to modify its behavior.
rem
rem '.\work\bc.exe' is needed when running in DOSBox; it can be deleted when running under
rem FreeDOS because FreeDOS has its own copy.
rem
rem This program is free software; it is released under the GNU General Public License version 2.
rem The XQUEST2.ZIP file is not free software.

if "%1" == ""      goto show_pre_help
if "%1" == "/?"    goto show_pre_help
if "%1" == "/h"    goto show_pre_help
if "%1" == "/help" goto show_pre_help
goto prep


:prep
    set HED=hed.com
    set XQ_BC=bc.exe
    set XQ_UNZIP=unzip.exe

    set PAT_FIL=.\xquest\xq-pat.exe
    set BC_FIL=_bc.tmp
    set HILO_FIL=_hilo.bat
    set PAT_INIT=
    set RUN_XQ=

    cd .\work

    rem Unzip XQUEST
    if not exist .\xquest %XQ_UNZIP% .\xquest2.zip -d xquest

    rem Check if unzip was successful. (Testing 'errorlevel' is sometimes not reliable.)
    if not exist .\xquest\xquest2.fnt got err_unzip

    rem Remove unneeded files.
    if exist unzip.exe   ren unzip.exe _unzip.exe
    if exist xquest2.zip ren xquest2.zip _xquest2.zip
    
    rem Make a copy of the original, which we will patch.
    if not exist %PAT_FIL% copy /y .\xquest\xquest.exe %PAT_FIL% > NUL

    
    goto process_args



:process_args
    if "%1" == ""             goto fin
    if "%1" == "/nodie"       goto patch_nodie
    if "%1" == "/aimedfire"   goto patch_aimedfire
    if "%1" == "/bombs"       goto patch_bombs
    if "%1" == "/bouncefire"  goto patch_bouncefire
    if "%1" == "/heavyfire"   goto patch_heavyfire
    if "%1" == "/level"       goto patch_level
    if "%1" == "/lives"       goto patch_lives
    if "%1" == "/multifire"   goto patch_multifire
    if "%1" == "/rapidfire"   goto patch_rapidfire
    if "%1" == "/rearfire"    goto patch_rearfire
    if "%1" == "/reset"       goto reset_patches
    if "%1" == "/run"         goto set_autorun
    if "%1" == "/shields"     goto patch_shields
    if "%1" == "/skipintro"   goto patch_skipintro

    if "%1" == "/h"           goto show_help
    if "%1" == "/help"        goto show_help

    goto err_bad_arg1

:cont_proc_args

    set HI_BYTE=
    set LO_BYTE=

    goto process_args


:parse_hilo
    if "%2" == "" goto err_miss_arg2

    rem The 'set' command in DOSBox does not support assigning a value by running a program
    rem so we use BC to create a .BAT file which will set HI_BYTE and LO_BYTE.
    echo here
    echo obase=16               >  %BC_FIL%
    echo print "@echo off\n"    >> %BC_FIL%
    echo print "set HI_BYTE="   >> %BC_FIL%
    echo %2 / 256               >> %BC_FIL%
    echo.                       >> %BC_FIL%
    echo print "set LO_BYTE="   >> %BC_FIL%
    echo %2 - (%2 / 256) * 256  >> %BC_FIL%
    echo.                       >> %BC_FIL%
    echo quit                   >> %BC_FIL%

    %XQ_BC% %BC_FIL% > %HILO_FIL%

    call %HILO_FIL%

    goto process_args


:show_pre_help
    cd .\work
:show_help
    echo Patch XQUEST2 to modify its behavior.
    echo Usage: XQ.BAT [OPTIONS]
    echo OPTIONS is one or more of the following:
    echo   /?, /h, /help  Show this text and exit
    echo   /bombs N       Number of smart bombs (Max: 999)
    echo   /level N       Starting level (Max: 50)
    echo   /lives N       Number of lives (Max: 999)
    echo   /nodie         Never die
    echo   /skipintro     Skip intro title screens
    echo   /run [ARGS]    Run patched version; [ARGS] will be passed to XQUEST2
    echo   /reset         Overwrite patched copy with original
    echo   /aimedfire  M
    echo   /bouncefire M
    echo   /heavyfire  M                 ___Power Ups___
    echo   /multifire  M      Max value of Power Ups is 65535 (0xFFFF)
    echo   /rapidfire  M      which provides about 15 minutes of use.
    echo   /rearfire   M
    echo   /shields    M
    echo Be careful when supplying high values as increases while playing can exceed the
    echo max which may cause program malfunction. If used, '/run' must be last.
    echo Patches are persistent and cummulative; use '/reset' to revert all patches.

    set PAT_INIT=
    set RUN_XQ=
    
    goto fin


:set_autorun
    set RUN_XQ=1
    shift
    goto fin










:patch_nodie
    %HED%  851f  90  %PAT_FIL%
    %HED%  8520  90  %PAT_FIL%
    shift
    goto cont_proc_args


:patch_aimedfire
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  132a2  %LO_BYTE%  %PAT_FIL%
    %HED%  132a3  %HI_BYTE%  %PAT_FIL%
    set PAT_INIT=1
    shift
    shift
    goto cont_proc_args



:patch_bombs
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  133fa  %LO_BYTE%  %PAT_FIL%
    %HED%  133fb  %HI_BYTE%  %PAT_FIL%
    shift
    shift
    goto cont_proc_args


:patch_bouncefire
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  132de  %LO_BYTE%  %PAT_FIL%
    %HED%  132df  %HI_BYTE%  %PAT_FIL%
    set PAT_INIT=1
    shift
    shift
    goto cont_proc_args


:patch_heavyfire
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  132d2  %LO_BYTE%  %PAT_FIL%
    %HED%  132d3  %HI_BYTE%  %PAT_FIL%
    set PAT_INIT=1
    shift
    shift
    goto cont_proc_args


:patch_level
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  133fe  %LO_BYTE%  %PAT_FIL%
    %HED%  133ff  %HI_BYTE%  %PAT_FIL%
    shift
    shift
    goto cont_proc_args


:patch_lives
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  133fc  %LO_BYTE%  %PAT_FIL%
    %HED%  133fd  %HI_BYTE%  %PAT_FIL%
    shift
    shift
    goto cont_proc_args


:patch_multifire
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  132ba  %LO_BYTE%  %PAT_FIL%
    %HED%  132bb  %HI_BYTE%  %PAT_FIL%
    set PAT_INIT=1
    shift
    shift
    goto cont_proc_args


:patch_rapidfire
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  132ae  %LO_BYTE%  %PAT_FIL%
    %HED%  132af  %HI_BYTE%  %PAT_FIL%
    set PAT_INIT=1
    shift
    shift
    goto cont_proc_args


:patch_rearfire
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  132c6  %LO_BYTE%  %PAT_FIL%
    %HED%  132c7  %HI_BYTE%  %PAT_FIL%
    set PAT_INIT=1
    shift
    shift
    goto cont_proc_args


:patch_shields
    if "%HI_BYTE%" == "" goto parse_hilo
    %HED%  13296  %LO_BYTE%  %PAT_FIL%
    %HED%  13297  %HI_BYTE%  %PAT_FIL%
    set PAT_INIT=1
    shift
    shift
    goto cont_proc_args


:patch_skipintro

    rem === Skip title0 ===

    rem Skip delay
    %HED%  c643  90  %PAT_FIL%
    %HED%  c644  90  %PAT_FIL%
    %HED%  c645  90  %PAT_FIL%

    rem Skip sound
    %HED%  c624  90  %PAT_FIL%
    %HED%  c625  90  %PAT_FIL%
    %HED%  c626  90  %PAT_FIL%

    rem Skip 100 ms sound delay
    %HED%  c628  01  %PAT_FIL%

    rem Skip fade-out
    %HED%  c66f  00  %PAT_FIL%


    rem === Skip title1 ===

    rem Skip delay
    %HED%  c7ce  90  %PAT_FIL%
    %HED%  c7cf  90  %PAT_FIL%
    %HED%  cfd0  90  %PAT_FIL%

    rem Skip sound
    %HED%  c7af  90  %PAT_FIL%
    %HED%  c7b0  90  %PAT_FIL%
    %HED%  c7b1  90  %PAT_FIL%

    rem Skip 100 ms sound delay
    %HED%  c7b3  01  %PAT_FIL%

    rem Skip fade-out
    %HED%  c7e6  00  %PAT_FIL%

    shift
    goto cont_proc_args


:reset_patches
    copy /y .\xquest\xquest.exe %PAT_FIL% > NUL
    set PAT_INIT=
    set RUN_XQ=
    shift
	goto cont_proc_args














:err_bad_arg1
    echo %0:err: Invalid arg: '%1'
    goto fin


:err_miss_arg2
    echo %0:err: '%1' requires a value.
    goto fin


:err_unzip
    echo %0:err: Error unzipping.
    set PAT_INIT=
    set RUN_XQ=
    goto fin


:fin

    if "%PAT_INIT%" == "1"  %HED%  b386  90  %PAT_FIL%
    if "%PAT_INIT%" == "1"  %HED%  b387  90  %PAT_FIL%
    if "%PAT_INIT%" == "1"  %HED%  b388  90  %PAT_FIL%

    if exist %BC_FIL%   del %BC_FIL%
    if exist %HILO_FIL% del %HILO_FIL%

    if "%RUN_XQ%" == "1" cd .\xquest
    if "%RUN_XQ%" == "1" xq-pat.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
    if "%RUN_XQ%" == "1" cd ..

    set BC_FIL=
    set HED=
    set HI_BYTE=
    set HILO_FIL=
    set LO_BYTE=
    set PAT_FIL=
    set PAT_INIT=
    set RUN_XQ=
    set XQ_BC=
    set XQ_UNZIP=
    
    rem Leave '.\work' directory.
    cd ..

