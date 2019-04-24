# =============================================================================
# FILE: mic_test.tcl
# AUTHOR: Sammy Carbajal
# =============================================================================
# PURPOSE: 
#   Simple LED test
# =============================================================================
# CONFIGURATION:
# =============================================================================
# COMPATIBILiTY:
#     Quartus 16.0    - DE1_SoC Board
#     Quartus 13.0sp1 - DE3 Board (AUDIO CODEC not supported)
# =============================================================================

# Loading routines
source default_master.tcl

set system_header ../../de1-soc/software/bsp/system.h

# Initialization
create_system_file $system_header

# Load system
source system.tcl

# Load module routines
source mic_if.tcl

open_default_master

set NUM_CH 4

proc mic_if_init {} {
  global NUM_CH
  for {set i 0} {$i<$NUM_CH} {incr i} {
    mic_if_channel_en $i 1
  }
  mic_if_saturation 1
  mic_if_round 1  
  mic_if_cic_osr 51
  mic_if_shift_right 11
  mic_if_clk_div 10
  mic_if_avalon_st_fil 0
  mic_if_avalon_st_aud 1
  mic_if_enable 1 
  mic_if_open_aud_bytestream
  
  mic_if_show_config
  mic_if_show_data $NUM_CH
}


#mic_if_init



