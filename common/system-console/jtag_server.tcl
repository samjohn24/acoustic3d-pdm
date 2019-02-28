# =============================================================================
# FILE: jtag_server.tcl
# DATE: 07-Feb-2019
# AUTHOR: Sammy Carbajal
# =============================================================================
# PURPOSE: 
#   TCP/IP Server for Altera JTAG
#   Code Derived from Tcl Developer Exchange 
#    - http://www.tcl.tk/about/netserver.html
# =============================================================================

# Loading routines
source default_master.tcl

set p_address 0
 
### Start server
# port: socket port
# mode: 0 - command, 1 - data
proc Start_Server {port mode} {
    if {$mode == 0} {
      set s [socket -server CmdConnAccept $port]
      puts "\[CMD\]: Started Command Socket Server on port - $port"
    } else {
      set s [socket -server DataConnAccept $port]
      puts "\[DAT\]: Started Data Socket Server on port - $port"
    }
    vwait forever
}
 
proc DataConnAccept {sock addr port} {
    global conn_data
    global p_path
    global p_address
    global sock_data

    # Open JTAG bytestream
    set p_path [open_bytestream $p_address]
 
    # Record the client's information
    puts "\[DAT\]: Accept $sock from $addr port $port"
    set conn_data(addr,$sock) [list $addr $port]

    set sock_data $sock

 
    # Ensure that each "puts" by the server
    # results in a network transmission
 
    fconfigure $sock -buffering line
 
    # Set up a callback for when the client sends data
    
    fileevent $sock readable [list IncomingData $sock]

}
 
proc IncomingData {sock} {
    global conn_data
    global p_path
 
    # Check end of file or abnormal connection drop,
    # then write the data to the vJTAG
 
    if {[eof $sock] || [catch {gets $sock line}]} {
    close $sock
    puts "\[DAT\]: Close $conn(addr,$sock)"
    unset conn_data(addr,$sock)
    } else {
    set recv_data [get_packet $p_path [expr 2*$line]]
    puts $sock $recv_data
    #puts $recv_data
    # TODO: Add recovery checking
    }
}

proc CmdConnAccept {sock addr port} {
    global conn_cmd

    # Open JTAG master
    #open_default_master
 
    # Record the client's information
 
    puts "\[CMD\]: Accept $sock from $addr port $port"
    set conn_cmd(addr,$sock) [list $addr $port]
 
    # Ensure that each "puts" by the server
    # results in a network transmission
 
    fconfigure $sock -buffering line
 
    # Set up a callback for when the client sends data
    
    fileevent $sock readable [list IncomingCmd $sock]
}

proc IncomingCmd {sock} {
    global conn_cmd
    global conn_data
    global p_address
    global s_data
 
    # Check end of file or abnormal connection drop,
    # then write the data to the vJTAG
 
    if {[eof $sock] || [catch {gets $sock line}]} {
      close $sock
      puts "\[CMD\]: Close $conn_cmd(addr,$sock)"
      unset conn_cmd(addr,$sock)
    } else {
      # Command parse
      set cmd [lindex $line 0]
      set arg0 [lindex $line 1]
      set arg1 [lindex $line 2]

      #puts "\tCommand $cmd received."
      if {$cmd == 0} {
         write_32 $arg0 $arg1
         set writevalue [format "%#010x" $arg1]
         set addressval [format "%#010x" $arg0]
         puts "\[CMD\]: Write $writevalue to $addressval address"
      } elseif {$cmd == 1} {
         set readvalue [format "%#010x" [read_32 $arg0 1]]
         set addressval [format "%#010x" $arg0]
         puts "\[CMD\]: Read $readvalue from $addressval address"
         puts $sock $readvalue
      } elseif {$cmd == 2} {
         puts "\[CMD\]: Close JTAG Master."
         close_default_master
      } elseif {$cmd == 3} {
         puts "\[CMD\]: Open JTAG Master."
         open_default_master
      } elseif {$cmd == 4} {
	 set p_address $arg1
	 if {[info exists s_data]} {
      	   puts "\[DAT\]: Data Socket Server on port - $arg0 already started"
    	   puts $sock 1
	 } else {
      	   set s_data [socket -server DataConnAccept $arg0]
      	   puts "\[DAT\]: Started Data Socket Server on port - $arg0"
    	   puts $sock 1
	 }
	 #TODO: Add routine to detect when is already connected
      } else {
         #puts "Unknown command num: $cmd. Ignoring."
      }
    }

}

# Get packet
proc get_packet {p_path num_bytes} {
  #set parsed {}
  set t0 [clock clicks -millisec]
  set recv_bytes [bytestream_receive $p_path [expr $num_bytes]]
  #set recv_bytes [lrepeat $num_bytes 0x32]
  #puts "[llength $recv_bytes] bytes to send: $recv_bytes"
  puts "time recv: [expr {[clock clicks -millisec]-$t0}] ms" 
  #foreach byte $recv_bytes {
    #append parsed [format %02x $byte]
  #}
  set parsed [binary format c* $recv_bytes]
  puts "time recv total: [expr {[clock clicks -millisec]-$t0}] ms" 
  set packet "[format %06d [string length $parsed]]$parsed"
  #puts $packet
  #set packet_show {}
  #foreach char [split $packet ""] {
  #  lappend packet_show [scan $char %c]
  #}
  #puts $packet_show
  return $packet
}

open_default_master

Start_Server 2540 0
