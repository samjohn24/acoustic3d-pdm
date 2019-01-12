
# =============================================================================
# FILE: led_test.tcl
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

open_default_master

# Write to LEDs sequentially
set i 0
while 1 {
  write_32 $LED_BASE [expr 0x01<<$i]
  sleep 2
  if {$i < 9} {
    incr i
  } else {
    set i 0
  }
}



