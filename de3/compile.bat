@echo off

:: Script to compile and generate files

:: Quartus installation directory

set QUARTUS_INSTALL_DIR="E:\altera\13.0sp1\quartus"

:: generate IPs
cd ip
call gen_bf_time_pcm.bat

cd ..

:: project file name

set PROJ_NAME=bf_time_pcm_de3



:: setup project
%QUARTUS_INSTALL_DIR%\bin64\quartus_sh -t setup_proj.tcl



:: Executing compilation
%QUARTUS_INSTALL_DIR%\bin64\quartus_sh --flow compile %PROJ_NAME%
