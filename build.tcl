# Set the reference directory to where the script is
set origin_dir [file dirname [info script]]

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir" { incr i; set origin_dir [lindex $::argv $i] }
      "--help"       { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/"]"

# Create project
create_project nmpsm3 $origin_dir/nmpsm3 -part xc7a35tcpg236-1 -force

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [get_projects nmpsm3]
set_property "default_lib" "xil_defaultlib" $obj
set_property "generate_ip_upgrade_log" "0" $obj
set_property "part" "xc7a35tcpg236-1" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "xpm_libraries" "XPM_CDC XPM_MEMORY" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/VGA.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/VGATest.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/uart.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/timer1.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/timer.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/seg7io.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/ROMcontroller.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/NMPSM3.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/LEDIO2.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/ledio.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/FF.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/div100k.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/dataMUX.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/ClockControl.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/Final_Project.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/AControl.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/I2CTest1.v"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/new/MControl.v"]"\
]
add_files -norecurse -fileset $obj $files

# Import local files from the original project
set files [list \
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/ip/Program_ROM/Program_ROM.xci"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/ip/Lookup_ROM/Lookup_ROM.xci"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/ip/clk25/clk25.xci"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/data_files/program.coe"]"\
 "[file normalize "$origin_dir/nmpsm3.srcs/sources_1/data_files/lookupROM.coe"]"\
]
set imported_files [import_files -fileset sources_1 $files]

# Set 'sources_1' fileset file properties for local files
set file "Program_ROM/Program_ROM.xci"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "0" $file_obj
}

set file "Lookup_ROM/Lookup_ROM.xci"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "0" $file_obj
}

set file "clk25/clk25.xci"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "0" $file_obj
}

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "Final_Project" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "target_constrs_file" "$origin_dir/nmpsm3.srcs/sources_1/constraints/Basys3_Master.xdc" $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 "[file normalize "$origin_dir/nmpsm3.srcs/sim_1/new/AControl_TB.v"]"\
]
add_files -norecurse -fileset $obj $files

set imported_files [import_files -fileset sim_1 $files]

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "AControl_TB" $obj
set_property "transport_int_delay" "0" $obj
set_property "transport_path_delay" "0" $obj
set_property "xelab.nosort" "1" $obj
set_property "xelab.unifast" "" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7a35tcpg236-1 -flow {Vivado Synthesis 2016} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2016" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property "needs_refresh" "1" $obj
set_property "part" "xc7a35tcpg236-1" $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7a35tcpg236-1 -flow {Vivado Implementation 2016} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2016" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "needs_refresh" "1" $obj
set_property "part" "xc7a35tcpg236-1" $obj
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:nmpsm3"
