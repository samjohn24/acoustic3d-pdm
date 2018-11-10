#!/bin/bash 
#Script to compile design

# Quartus installation directory
export QUARTUS_INSTALL_DIR=/opt/altera_lite/16.0/quartus

# Project file name
export PROJ_NAME=bf_time_pcm_de1_soc

# Compile IPs
cd ip
source gen_bf_time_pcm.sh
source gen_ALTCLKCTRL.sh
cd ..

# Create project
$QUARTUS_INSTALL_DIR/bin64/quartus_sh -t setup_proj.tcl

# Run compilation
$QUARTUS_INSTALL_DIR/bin64/quartus_sh --flow compile $PROJ_NAME
