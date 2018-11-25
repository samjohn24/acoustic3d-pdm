set_global_assignment -entity "ALT_PLL" -library "lib_ALT_PLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "ALT_PLL" -library "lib_ALT_PLL" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "ALT_PLL" -library "lib_ALT_PLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_ALT_PLL" -name SPD_FILE [file join $::quartus(sip_path) "ALT_PLL.spd"]

set_global_assignment -library "lib_ALT_PLL" -name MISC_FILE [file join $::quartus(sip_path) "ALT_PLL_sim/ALT_PLL.vo"]
