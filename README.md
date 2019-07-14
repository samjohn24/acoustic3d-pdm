# bf_time_pcm - Time-domain Delay-and-Sum Beamformer

FPGA implementation of a conventional time-domain Delay-and-Sum (DAS) beamformer for Terasic DE1-SoC using Beaglebone Black Microphone Array board.

## Dependencies

Following is the list of dependencies and the expected location path:

### For testing

- Avalon-ST JTAG: ../ip/avalon_st_jtag 
- MIC-IF: ../ip/mic_if
- bf_tester: ../../software/bf_tester

### For FPGA compilation

In addition to testing dependencies:

- Terasic IPs: ../ip_terasic/ 

## Instructions

### For testing

1. In de1-soc/ folder execute ./program.sh
2. Start the server executing ./run_server in ../ip/avalon_st_jtag/system-console folder.
3. Start the 3D viewer executing ./mic_plot_3d.py In ../../software/bf_tester/tests folder.

## For FPGA compilation

In de1-soc/ folder execute ./compile.sh


