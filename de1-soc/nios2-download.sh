#!/bin/bash
# Script to download a ELF file 

# Quartus installation directory
if [ -n $NIOS2EDS_INSTALL_DIR ]; then
  export NIOS2EDS_INSTALL_DIR=/opt/altera_lite/16.0/nios2eds
fi

# Output directory
if [ -n $NIOS2_OUTPUT_DIR ]; then
  export NIOS2_OUTPUT_DIR=./software/
fi

# ELF file
if [ -n $NIOS2_ELF ]; then
  export NIOS2_ELF=bf_time_pcm_de1_soc.elf
fi


$NIOS2EDS_INSTALL_DIR/nios2_command_shell.sh nios2-download $NIOS2_OUTPUT_DIR/app/$NIOS2_ELF -c 1 -r -g
$NIOS2EDS_INSTALL_DIR/nios2_command_shell.sh nios2-terminal -c 1 --no-quit-on-ctrl-d 
