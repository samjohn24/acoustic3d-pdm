#!/bin/bash
# Script to generate HDL files from Qsys system  

# Quartus installation directory
#export QUARTUS_INSTALL_DIR=/opt/altera_lite/16.0/quartus

# Qsys file name
export QSYS_FILENAME=bf_time_pcm

# Qsys path
export QSYS_PATH=../../common/qsys/

# Qsys filepath
export QSYS_FILEPATH=$QSYS_PATH/$QSYS_FILENAME

# Output directory
export OUTPUT_DIR=../ip/$QSYS_FILENAME

# Device part
export DEVICE_PART=5CSEMA5F31C6

#$QUARTUS_INSTALL_DIR/sopc_builder/bin/qsys-generate $QSYS_FILEPATH.qsys --synthesis=VERILOG --simulation=VERILOG --testbench --testbench-simulation --output-directory=$OUTPUT_DIR --part=$DEVICE_PART --clear-output-directory
$QUARTUS_INSTALL_DIR/sopc_builder/bin/qsys-generate $QSYS_FILEPATH.qsys --synthesis=VERILOG --output-directory=$OUTPUT_DIR --part=$DEVICE_PART --clear-output-directory

mv $QSYS_PATH/*.sopcinfo $OUTPUT_DIR
mv $QSYS_PATH/*.csv $OUTPUT_DIR
mv $QSYS_PATH/*.spd $OUTPUT_DIR
