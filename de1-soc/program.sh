#!/bin/bash
#Script to program DE1-SOC device

# Quartus installation directory
export QUARTUS_INSTALL_DIR=/opt/altera_lite/16.0/quartus

# Project file name
export PROJ_NAME=bf_time_pcm_de1_soc

# Program file
export PROGRAM_FILE=output_files/${PROJ_NAME}_time_limited.sof

# Program device
#quartus_pgm -c DE-SOC -m JTAG -o "P;$PROGRAM_FILE;5CSEMA5@2"
quartus_pgm -c 1 -m JTAG -o "P;$PROGRAM_FILE;5CSEMA5@2"
