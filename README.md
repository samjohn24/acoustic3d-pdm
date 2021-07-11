# Acoustic3D-pdm: A FPGA implementation of an acoustic 3D camera using a PDM-domain Delay-and-Sum (DAS) beamformer

Implemented in a [Terasic DE1-SoC](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836) using a [Beaglebone Black Microphone Array board](https://github.com/marcelodaher/memsarray).

## Dependencies

Following is the list of dependencies and the expected location paths:

- [Avalon-ST JTAG](https://github.com/samjohn24/avalon_st_jtag) (1.2.0): ../ip/avalon_st_jtag 
- [MIC-IF](https://github.com/samjohn24/mic_if) (1.4.1): ../ip/mic_if
- [bf_tester](https://github.com/samjohn24/bf_tester) (1.2.0): ../bf_tester

### Additional dependencies for a full compilation

In addition to testing dependencies:

- Terasic IPs (1.1.0): ../ip_terasic 
- [PWM CTRL](https://github.com/samjohn24/pwm_ctrl) (1.0.0): ../ip/pwm_ctrl

## Connection

See the connection diagram [here](doc/bbb2de1soc.svg).

## Running the 3D camera

1. Clone dependencies in paths mentioned above.
2. In de1-soc/ folder execute `./program.sh`
3. Start the server executing `./run_server` in ../ip/avalon_st_jtag/system-console folder.
4. Start the 3D viewer executing `./mic_plot_3d.py` In ../bf_tester folder.

## Re-compiling FPGA images

Clone additional dependencies and in de1-soc/ folder execute `./compile.sh`

## References

* CARBAJAL IPENZA, Sammy Johnatan. Efficient pulse-density modulated microphone array processing: Processamento eficiente de arranjos de microfones modulados em densidade de pulso. 2020. 1 recurso online (125 p.) Dissertação (mestrado) - Universidade Estadual de Campinas, Faculdade de Engenharia Elétrica e de Computação, Campinas, SP. ([link](http://repositorio.unicamp.br/jspui/handle/REPOSIP/356372))
