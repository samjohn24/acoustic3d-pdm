#!/bin/bash
# Script to build a Nios2 project

# Quartus installation directory
if [ -n $NIOS2EDS_INSTALL_DIR ]; then
  export NIOS2EDS_INSTALL_DIR=/opt/altera_lite/16.0/nios2eds
fi

# .sopcinfo file
if [ -n $SOPCINFO_FILE ]; then
  export SOPCINFO_FILE=ip/bf_time_pcm/bf_time_pcm.sopcinfo
fi

# Include directory
if [ -n $NIOS2_SOURCE_DIR ]; then
  export NIOS2_SOURCE_DIR=../common/nios2
fi

# Quartus installation directory
if [ -n $MIC_IF_DIR ]; then
  export MIC_IF_DIR=../../ip/mic_if/nios2/hal
fi

# AUDIO_SUBSYS directory
if [ -n $AUDIO_SUBSYS_DIR ]; then
  export AUDIO_SUBSYS_DIR=../../ip_terasic/TERASIC_AUDIO_SUBSYS/nios2/hal
fi

# SEG7 directory
if [ -n $SEG7_DIR ]; then
  export SEG7_DIR=../../ip_terasic/TERASIC_SEG7/nios2/hal
fi

# Output directory
export NIOS2_OUTPUT_DIR=./software/

# ELF file
export NIOS2_ELF=bf_time_pcm_de1_soc.elf

# Build
echo "Generating BSP..."

$NIOS2EDS_INSTALL_DIR/nios2_command_shell.sh nios2-bsp hal $NIOS2_OUTPUT_DIR/bsp $SOPCINFO_FILE 
cd $NIOS2_OUTPUT_DIR/bsp
$NIOS2EDS_INSTALL_DIR/nios2_command_shell.sh make
cd -

echo "Generating the Nios2 application..."

rm -rf $NIOS2_OUTPUT_DIR/app

$NIOS2EDS_INSTALL_DIR/nios2_command_shell.sh nios2-app-generate-makefile --bsp-dir $NIOS2_OUTPUT_DIR/bsp --app-dir $NIOS2_OUTPUT_DIR/app\
 --src-rdir $NIOS2_SOURCE_DIR/src --inc-rdir $NIOS2_SOURCE_DIR/inc \
 --inc-rdir $MIC_IF_DIR/inc --src-rdir $MIC_IF_DIR/src \
 --inc-rdir $AUDIO_SUBSYS_DIR/inc --src-rdir $AUDIO_SUBSYS_DIR/src \
 --inc-rdir $SEG7_DIR/inc --src-rdir $SEG7_DIR/src \
 --elf-name $NIOS2_ELF 

cd $NIOS2_OUTPUT_DIR/app

$NIOS2EDS_INSTALL_DIR/nios2_command_shell.sh make

cd -

