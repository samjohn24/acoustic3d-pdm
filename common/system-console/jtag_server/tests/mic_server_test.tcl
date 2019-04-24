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

mic_if_init
Start_Server 2540 1

#puts "Hello"


