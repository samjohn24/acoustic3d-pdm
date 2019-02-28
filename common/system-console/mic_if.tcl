# =============================================================================
# FILE: mic_if.tcl
# DATE: 07-Feb-2019
# AUTHOR: Sammy Carbajal
# =============================================================================
# PURPOSE: 
#   Microfone Interface routines to be used on system-console
# =============================================================================

# Register offset
set MIC_IF_CTRL_1_REG_ADDR   0x00
#set MIC_IF_CTRL_2_REG_ADDR   0x01
set MIC_IF_CTRL_2_REG_ADDR 1
set MIC_IF_CTRL_3_REG_ADDR   0x02
set MIC_IF_CTRL_4_REG_ADDR   0x03
set MIC_IF_STATUS_REG_ADDR   0x06
set MIC_IF_SUM_DATA_REG_ADDR 0x0A
set MIC_IF_DATA_REG_ADDR     0x10
set MIC_IF_DELAY_REG_ADDR    0x50

# Bitfield offsets and masks
set MIC_IF_OFF_MICEN 	31
set MIC_IF_MASK_MICEN 	0x80000000
set MIC_IF_OFF_SAT 		30
set MIC_IF_MASK_SAT 	0x40000000
set MIC_IF_OFF_ROUND 	29
set MIC_IF_MASK_ROUND 	0x20000000
set MIC_IF_OFF_LRSEL 	28
set MIC_IF_MASK_LRSEL 	0x10000000

set MIC_IF_OFF_CICOSR 	16
set MIC_IF_MASK_CICOSR 	0x00ff0000
set MIC_IF_OFF_SHIFTROUT 	8
set MIC_IF_MASK_SHIFTROUT 	0x0000ff00
set MIC_IF_OFF_CLKDIV 	0
set MIC_IF_MASK_CLKDIV 	0x000000ff

set MIC_IF_OFF_CHEN 	0

set MIC_IF_OFF_AUD_ST_DIS  31
set MIC_IF_OFF_FIL_ST_DIS  30
set MIC_IF_OFF_BF_ST_EN    29
set MIC_IF_OFF_FFTPTS  	   0

set MIC_IF_OFF_DREADY 	0
set MIC_IF_MASK_DREADY 	0x1

set MIC_IF_OFF_DELAY 	0
set MIC_IF_MASK_DELAY 	0x0000ffff

# =================
#  Aid procedures
# =================

# Write register
proc mic_if_write {index seg_mask} {
  global MIC_IF_BASE
  write_32 [expr $MIC_IF_BASE+$index*4] $seg_mask    
}

# Read register
proc mic_if_read {index num} {
  global MIC_IF_BASE
  return [read_32 [expr $MIC_IF_BASE+$index*4] $num]
}

# Set bit
proc mic_if_setbit {index offset} {
  mic_if_write $index [expr [mic_if_read $index 1]|0x01<<$offset]
}

# Clear bit
proc mic_if_clrbit {index offset} {
  mic_if_write $index [expr [mic_if_read $index 1]&~(0x01<<$offset)]
}

# Set mask
proc mic_if_setmask {index value offset mask} {
  mic_if_write $index [expr ([mic_if_read $index 1] & ~$mask)|($value<<$offset)]
}

# =============================
#  Module specific procedures 
# =============================

# Module enable 
proc mic_if_enable {value} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_OFF_MICEN
  if {$value} {
    mic_if_setbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_MICEN 
    puts "MIC_IF: Interface enabled."
  } else {
    mic_if_clrbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_MICEN
    puts "MIC_IF: Interface disabled."
  }
}

# Clock divider
proc mic_if_clk_div {value} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_OFF_CLKDIV
  global MIC_IF_MASK_CLKDIV
  mic_if_setmask $MIC_IF_CTRL_1_REG_ADDR $value $MIC_IF_OFF_CLKDIV $MIC_IF_MASK_CLKDIV 
  puts [format "MIC_IF: CLKDIV=%x" $value]
}

# Shift-right output
proc mic_if_shift_right {value} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_OFF_SHIFTROUT
  global MIC_IF_MASK_SHIFTROUT
  mic_if_setmask $MIC_IF_CTRL_1_REG_ADDR $value $MIC_IF_OFF_SHIFTROUT $MIC_IF_MASK_SHIFTROUT
  puts [format "MIC_IF: SHIFTROUT=%x" $value]
}

# CIC Oversampling rate
proc mic_if_cic_osr {value} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_OFF_CICOSR
  global MIC_IF_MASK_CICOSR
  mic_if_setmask $MIC_IF_CTRL_1_REG_ADDR $value $MIC_IF_OFF_CICOSR $MIC_IF_MASK_CICOSR
  puts [format "MIC_IF: CICOSR=%x" $value]
}

# FFT points log2
proc mic_if_fft_pts {value} {
  global MIC_IF_CTRL_4_REG_ADDR
  global MIC_IF_OFF_FFTPTS
  mic_if_write $MIC_IF_CTRL_4_REG_ADDR $value+$MIC_IF_OFF_FFTPTS
  puts [format "MIC_IF: 2^%x FFT points" $value]
}

# Saturation enable 
proc mic_if_saturation {value} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_OFF_SAT
  if {$value} {
    mic_if_setbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_SAT 
    puts "MIC_IF: Saturation enabled."
  } else {
    mic_if_clrbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_SAT 
    puts "MIC_IF: Saturation disabled."
  }
}

# Round-off enable
proc mic_if_round {value} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_OFF_ROUND
  if {$value} {
    mic_if_setbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_ROUND
    puts "MIC_IF: Round-off enabled."
  } else {
    mic_if_clrbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_ROUND
    puts "MIC_IF: Round-off disabled."
  }
}

# Channel enable
proc mic_if_channel_en {num value} {
  global MIC_IF_OFF_CHEN
  global MIC_IF_CTRL_2_REG_ADDR
  global MIC_IF_CTRL_3_REG_ADDR

  if {$value} {
    if {$num < 32} {
      mic_if_setbit $MIC_IF_CTRL_2_REG_ADDR [expr $num+$MIC_IF_OFF_CHEN]

    } else {
      mic_if_setbit $MIC_IF_CTRL_3_REG_ADDR [expr $num+$MIC_IF_OFF_CHEN]
    }
    puts [format "MIC_IF: Channel %d enabled." $num]
  } else {
    if {$num < 32} {
      mic_if_clrbit $MIC_IF_CTRL_2_REG_ADDR [expr $num+$MIC_IF_OFF_CHEN]
    } else {
      mic_if_clrbit $MIC_IF_CTRL_3_REG_ADDR [expr $num+$MIC_IF_OFF_CHEN]
    }
    puts [format "MIC_IF: Channel %d disabled." $num]
  }
}

# Get data
proc mic_if_get_data {index} {
  global MIC_IF_DATA_REG_ADDR
  return [mic_if_read [expr $MIC_IF_DATA_REG_ADDR+$index] 1] 
}

# Dump data ('num' first channels)
proc mic_if_dump_data {num} {
  global MIC_IF_DATA_REG_ADDR
  return [mic_if_read $MIC_IF_DATA_REG_ADDR $num] 
}

# Get sum data
#
proc mic_if_get_sum_data {} {
  global MIC_IF_SUM_DATA_REG_ADDR
  return [mic_if_read $MIC_IF_SUM_DATA_REG_ADDR 1] 
}

# Data ready
proc mic_if_ready {} {
  global MIC_IF_STATUS_REG_ADDR
  global MIC_IF_MASK_DREADY
  return [expr [mic_if_read $MIC_IF_STATUS_REG_ADDR 1] & $MIC_IF_MASK_DREADY]
}

# Clear data ready
proc mic_if_clr_ready {} {
  global MIC_IF_STATUS_REG_ADDR
  global MIC_IF_OFF_DREADY
  mic_if_setbit $MIC_IF_STATUS_REG_ADDR $MIC_IF_OFF_DREADY
}

# Get delay
proc mic_if_get_delay {num} {
  global MIC_IF_DELAY_REG_ADDR
  return [mic_if_read $MIC_IF_DELAY_REG_ADDR+$num 1] 
}

# Set delay
proc mic_if_set_delay {num value} {
  global MIC_IF_DELAY_REG_ADDR
  mic_if_write $MIC_IF_DELAY_REG_ADDR+$num $value
}

# Set Left-Right
proc mic_if_set_right {value} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_OFF_LRSEL
  if {$value} {
    mic_if_setbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_LRSEL
    puts "MIC_IF: Clock control set to right."
  } else {
    mic_if_clrbit $MIC_IF_CTRL_1_REG_ADDR $MIC_IF_OFF_LRSEL
    puts "MIC_IF: Clock control set to left."
  }
}

# Avalon-ST interface
proc mic_if_avalon_st_aud {value} {
  global MIC_IF_CTRL_4_REG_ADDR
  global MIC_IF_OFF_AUD_ST_DIS
  if {$value} {
    mic_if_clrbit $MIC_IF_CTRL_4_REG_ADDR $MIC_IF_OFF_AUD_ST_DIS
    puts "MIC_IF: Avalon-ST Audio interface enabled."
  } else {
    mic_if_setbit $MIC_IF_CTRL_4_REG_ADDR $MIC_IF_OFF_AUD_ST_DIS
    puts "MIC_IF: Avalon-ST Audio interface disabled."
  }
}

# Avalon-ST interface
proc mic_if_avalon_st_fil {value} {
  global MIC_IF_CTRL_4_REG_ADDR
  global MIC_IF_OFF_FIL_ST_DIS
  if {$value} {
    mic_if_clrbit $MIC_IF_CTRL_4_REG_ADDR $MIC_IF_OFF_FIL_ST_DIS
    puts "MIC_IF: Avalon-ST Filter interface enabled."
  } else {
    mic_if_setbit $MIC_IF_CTRL_4_REG_ADDR $MIC_IF_OFF_FIL_ST_DIS
    puts "MIC_IF: Avalon-ST Filter interface disabled."
  }
}

# Avalon-ST Beamformer interface
proc mic_if_avalon_st_beam {value} {
  global MIC_IF_CTRL_4_REG_ADDR
  global MIC_IF_OFF_BF_ST_EN
  if {$value} {
    mic_if_setbit $MIC_IF_CTRL_4_REG_ADDR $MIC_IF_OFF_BF_ST_EN
    puts "MIC_IF: Avalon-ST Beamformer interface enabled."
  } else {
    mic_if_clrbit $MIC_IF_CTRL_4_REG_ADDR $MIC_IF_OFF_BF_ST_EN
    puts "MIC_IF: Avalon-ST Beamformer interface disabled."
  }
}

# Read configuration
proc mic_if_show_config {} {
  global MIC_IF_CTRL_1_REG_ADDR
  global MIC_IF_CTRL_2_REG_ADDR
  global MIC_IF_CTRL_3_REG_ADDR
  global MIC_IF_CTRL_4_REG_ADDR
  global MIC_IF_STATUS_REG_ADDR

  puts [format "MIC_IF: CTRL_1: %#010x" [mic_if_read $MIC_IF_CTRL_1_REG_ADDR 1]]
  puts [format "MIC_IF: CTRL_2: %#010x" [mic_if_read $MIC_IF_CTRL_2_REG_ADDR 1]]
  puts [format "MIC_IF: CTRL_3: %#010x" [mic_if_read $MIC_IF_CTRL_3_REG_ADDR 1]]
  puts [format "MIC_IF: CTRL_4: %#010x" [mic_if_read $MIC_IF_CTRL_4_REG_ADDR 1]]
  puts [format "MIC_IF: STATUS: %#010x" [mic_if_read $MIC_IF_STATUS_REG_ADDR 1]]
}

# Read configuration
proc mic_if_show_data {NUM_CH} {
  set dump_data [mic_if_dump_data $NUM_CH]
  for {set i 0} {$i<$NUM_CH} {incr i} {
    #puts [format "MIC_IF: DATA_%d:  %#010x" $i [mic_if_get_data $i ]]
    puts [format "MIC_IF: DATA_%d:  %#010x" $i [lindex $dump_data $i]]
  }
}

# Read N samples
proc mic_if_read_samples {N} {
  set i 0
  while {$i < $N} {
    while {![mic_if_ready] } {}
    mic_if_show_data
    mic_if_clr_ready
    incr i
  }
}

# Open bytestream audio
proc mic_if_open_aud_bytestream {} {
  global p_bytestream
  set p_bytestream [get_default_bytestream]
  open_service bytestream $p_bytestream 
  puts "JTAG UART opened: $p_bytestream" 
}

# Open bytestream audio
proc mic_if_open_jtag_bytestream {index} {
  global p_bytestream
  set p_bytestream [get_default_bytestream]
  open_service bytestream $p_bytestream 
  puts "JTAG UART opened: $p_bytestream" 
}

# Get audio packet
proc mic_if_get_packet {num_bytes} {
  set parsed {}
  foreach byte [mic_if_get_aud_data $num_bytes] {
    append parsed [format %02x $byte]
  }
  return $parsed
}


# Read data bytestream
proc mic_if_get_aud_data {num_bytes} {
  global p_bytestream
  return [bytestream_receive $p_bytestream $num_bytes]
}

# Initialization
proc mic_if_init {} {
  global NUM_CH
  mic_if_enable 0 
  for {set i 0} {$i<$NUM_CH} {incr i} {
    mic_if_channel_en $i 1
  }
  mic_if_saturation 1
  mic_if_round 1  
  mic_if_cic_osr 51
  mic_if_shift_right 17
  mic_if_clk_div 10
  mic_if_avalon_st_fil 0
  mic_if_avalon_st_aud 1
  mic_if_enable 1 
  mic_if_open_aud_bytestream
  
  mic_if_show_config
  mic_if_show_data $NUM_CH
}


# ======================
#     TCP/IP Server
# ======================
 
#Code Derived from Tcl Developer Exchange - http://www.tcl.tk/about/netserver.html
 
### Start server
# port: socket port
# mode: 0 - command, 1 - data
proc Start_Server {port mode} {
    if {$mode == 0} {
      set s [socket -server CmdConnAccept $port]
      puts "Started Command Socket Server on port - $port"
    } else {
      set s [socket -server DataConnAccept $port]
      puts "Started Data Socket Server on port - $port"
    }
    vwait forever
}
 
proc DataConnAccept {sock addr port} {
    global conn
    global p_data

    # Open JTAG bytestream
    set p_data [open_bytestream 0]
 
    # Record the client's information
 
    puts "Accept $sock from $addr port $port"
    set conn(addr,$sock) [list $addr $port]
 
    # Ensure that each "puts" by the server
    # results in a network transmission
 
    fconfigure $sock -buffering line
 
    # Set up a callback for when the client sends data
    
    fileevent $sock readable [list IncomingData $sock]
}
 
proc IncomingData {sock} {
    global conn
 
    # Check end of file or abnormal connection drop,
    # then write the data to the vJTAG
 
    if {[eof $sock] || [catch {gets $sock line}]} {
    close $sock
    puts "Close $conn(addr,$sock)"
    unset conn(addr,$sock)
    } else {
    set send_data [bytestream_receive $p_data [expr 2*$line]]
    puts $sock $send_data
    #puts $send_data
    # TODO: Add recovery checking
    }
}

proc CmdConnAccept {sock addr port} {
    global conn
    global p_cmd

    # Open JTAG master
    set p_cmd [open_default_master]
 
    # Record the client's information
 
    puts "Accept $sock from $addr port $port"
    set conn(addr,$sock) [list $addr $port]
 
    # Ensure that each "puts" by the server
    # results in a network transmission
 
    fconfigure $sock -buffering line
 
    # Set up a callback for when the client sends data
    
    fileevent $sock readable [list IncomingCmd $sock]
}

proc IncomingCmd {sock} {
    global conn
 
    # Check end of file or abnormal connection drop,
    # then write the data to the vJTAG
 
    if {[eof $sock] || [catch {gets $sock line}]} {
      close $sock
      puts "Close $conn(addr,$sock)"
      unset conn(addr,$sock)
    } else {
      #set send_data [mic_if_get_packet [expr 2*$line]]
      #puts $sock $send_data
      set cmd [lindex $line 0]
      set arg0 [lindex $line 1]
      set arg1 [lindex $line 2]

      if {$cmd == 0} {
         write_32 $arg0 $arg1
         puts "Write $arg1 to $arg0 address"
      } elseif {$cmd == 1} {
         set readvalue [format "%#010x" [read_32 $arg0 1]]
         puts "Read $readvalue from $arg0 address"
         puts $sock $readvalue
      } elseif {$cmd == 2} {
         puts "Close JTAG Master"
         close_default_master
      } else {
         puts "Unknown command num: $cmd. Ignoring."
      }
    }

}

