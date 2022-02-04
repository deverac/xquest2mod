@echo off
rem This will build XQuest2. It should work with Turbo Pascal 6 or 7.
rem The Turbo Pascal compiler (tpc.exe) must be in the PATH.

cd ./xq2
    rem   /B    Build all units
    rem   /$G+  Generate 286 instructions
    tpc /B /$G+ xquest.pas
    del *.TPU
cd ..
