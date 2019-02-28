
# The following procedures assume that there's only one master available
# in the device. They just take the first master that is returned by
# get_service_paths. In systems with only one controllable master, the
# first master will be that. In systems with more than one controllable
# master, the outcome is undetermined. Feel free to use these procedures
# with systems that contain only one controllable master 

# Creates a system.tcl file from a header
proc create_system_file {header} { 
   if {![file exists system.tcl]} {
     exec cat $header | grep define | sed -En {s/#define\s(\S+)\s(\S+)/set \1 \2/p} > system.tcl
     puts "system.tcl created.\n"
   }
}

# Sleep N seconds
proc sleep N {
    after [expr {int($N * 1000)}]
}


# Returns the first bytestream service in the system.
proc get_default_bytestream {} {
	return [ lindex [ get_service_paths bytestream ] 0 ]
}

# Returns the a bytestream service in the system.
proc get_bytestream {num} {
	return [ lindex [ get_service_paths bytestream ] $num ]
}


# Open the first bytestream service in the system.
proc open_default_bytestream {} {
  set p0 [ get_default_bytestream ]
  open_service bytestream $p0
  puts $p0
}

# Open a bytestream service in the system.
proc open_bytestream {num} {
  set p0 [ get_bytestream $num ]
  open_service bytestream $p0
  puts "JTAG Bytestream opened: $p0" 
  return $p0
}

# Receive data
proc get_bytestream_data {index num_bytes} {
  return [bytestream_receive [get_bytestream $index] $num_bytes]
}

# Returns the first master in the system.
proc get_default_master {} {
	return [ lindex [ get_service_paths master ] 0 ]
}


# Open the first master in the system.
proc open_default_master {} {
  set p0 [ get_default_master ]
  open_service master $p0
  puts "JTAG Master opened: $p0"
  return $p0
}

# Close the first master in the system.
proc close_default_master {} {
  set p0 [ get_default_master ]
  close_service master $p0
  puts $p0
}

# Check the first master in the system is connected.
proc is_default_master_open {} {
  set p0 [ get_default_master ]
  return [is_service_open master $p0]
}

# Write the list of byte values starting at address using the default
# master
proc write_memory { address values } {
  set p0 [ get_default_master ]
  master_write_memory $p0 $address $values
}

proc write_8 { address values } {
  set p0 [ get_default_master ]
  master_write_8 $p0 $address $values
}

proc write_16 { address values } {
  set p0 [ get_default_master ]
  master_write_16 $p0 $address $values
}

proc write_32 { address values } {
  set p0 [ get_default_master ]
  master_write_32 $p0 $address $values
}

# Read size number of bytes starting at address using the default
# master
proc read_memory { address size } {
  set p0 [ get_default_master ]
  return [ master_read_memory $p0 $address $size ]
}

proc read_8 { address size } {
  set p0 [ get_default_master ]
  return [ master_read_8 $p0 $address $size ]
}

proc read_16 { address size } {
  set p0 [ get_default_master ]
  return [ master_read_16 $p0 $address $size ]
}

proc read_32 { address size } {
  set p0 [ get_default_master ]
  return [ master_read_32 $p0 $address $size ]
}
