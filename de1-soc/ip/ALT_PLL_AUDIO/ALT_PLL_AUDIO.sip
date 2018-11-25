set_global_assignment -entity "ALT_PLL_AUDIO" -library "lib_ALT_PLL_AUDIO" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "ALT_PLL_AUDIO" -library "lib_ALT_PLL_AUDIO" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "ALT_PLL_AUDIO" -library "lib_ALT_PLL_AUDIO" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_ALT_PLL_AUDIO" -name SPD_FILE [file join $::quartus(sip_path) "ALT_PLL_AUDIO.spd"]

set_global_assignment -library "lib_ALT_PLL_AUDIO" -name MISC_FILE [file join $::quartus(sip_path) "ALT_PLL_AUDIO_sim/ALT_PLL_AUDIO.vo"]
