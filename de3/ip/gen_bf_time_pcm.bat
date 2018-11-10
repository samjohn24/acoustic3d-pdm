@echo off

:: Script to generate HDL files from Qsys system  



:: Quartus installation directory

:: set QUARTUS_INSTALL_DIR="E:\altera\13.0sp1\quartus"

:: Qsys file name

set QSYS_FILENAME=bf_time_pcm


:: Qsys path

set QSYS_PATH=..\..\common\qsys


:: Qsys file path

set QSYS_FILEPATH=%QSYS_PATH%\%QSYS_FILENAME%





:: Output directory

set OUTPUT_DIR=..\ip\%QSYS_FILENAME%



:: Device part

set DEVICE_PART="EP3SL150F1152C2"



:: Executing Qsys


%QUARTUS_INSTALL_DIR%\sopc_builder\bin\qsys-generate %QSYS_FILEPATH%.qsys --synthesis=VERILOG --output-directory=%OUTPUT_DIR% --part=%DEVICE_PART% --clear-output-directory




REM Moving files

move %QSYS_PATH%\*.sopcinfo %OUTPUT_DIR% 
move %QSYS_PATH%\*.csv %OUTPUT_DIR%
move %QSYS_PATH%\*.spd %OUTPUT_DIR%
move %QSYS_PATH%\*.cmp %OUTPUT_DIR%
move %QSYS_PATH%\*.html %OUTPUT_DIR%
move %QSYS_PATH%\*.rpt %OUTPUT_DIR%

