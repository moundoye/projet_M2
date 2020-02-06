###############################################################################
 #  Copyright (c) 2018, Xilinx, Inc.
 #  All rights reserved.
 #
 #  Redistribution and use in source and binary forms, with or without
 #  modification, are permitted provided that the following conditions are met:
 #
 #  1.  Redistributions of source code must retain the above copyright notice,
 #     this list of conditions and the following disclaimer.
 #
 #  2.  Redistributions in binary form must reproduce the above copyright
 #      notice, this list of conditions and the following disclaimer in the
 #      documentation and/or other materials provided with the distribution.
 #
 #  3.  Neither the name of the copyright holder nor the names of its
 #      contributors may be used to endorse or promote products derived from
 #      this software without specific prior written permission.
 #
 #  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 #  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 #  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 #  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 #  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 #  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 #  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 #  OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 #  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 #  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 #  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #
###############################################################################
 # @file create_proj.tcl
 #
 #	Tcl script for re-creating project Video Series 22
 # 
 #
###############################################################################
################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version "2018.1 2018.2 2018.3 2019.1"
set current_vivado_version [version -short]

if { [string first $current_vivado_version $scripts_vivado_version] == -1 } {
   puts "The version $current_vivado_version is not supported. Supported versions are $scripts_vivado_version"
   return 1
}

# Configuration - Can be modified by the user
set project_name 				proj_1
set BD_name 					ZC702_HDMI

# Create a new project
variable board
set default_board "ZC702 PYNQZ2"

if { [string first $board $default_board] == -1} {
		puts "$board is not supported. board supported are $default_board."
		puts "First set the board by running : set board ZC702 or set board PYNQZ2"
		puts "And after source the project" 
		return -1
	}
	
if { [string equal $board PYNQZ2] == 0} {
		create_project $project_name ./$project_name -part xc7z020clg484-1
		set_property board_part xilinx.com:zc702:part0:1.4 [current_project]
		set_property target_language Verilog [current_project]
	} else {
		create_project $project_name ./$project_name -part xc7z020clg400-1
		set_property board_part tul.com.tw:pynq-z2:part0:1.0 [current_project]
		set_property target_language Verilog [current_project]
	}

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
# Add hdl files
#add_files -fileset sources_1 -norecurse -scan_for_includes ./src/hdl
#import_files -fileset sources_1 -norecurse ./src/hdl

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset -quiet constrs_1
}
# Add constraint files
if { [string equal $board PYNQZ2] == 0} {
		add_files -fileset constrs_1 -norecurse -scan_for_includes ./src/constr
		import_files -fileset constrs_1 -norecurse ./src/constr/ZC702
	} else {
		add_files -fileset constrs_1 -norecurse -scan_for_includes ./src/constr
		import_files -fileset constrs_1 -norecurse ./src/constr/PYNQZ2
	}

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
# Add simulation files
add_files -fileset sim_1 -norecurse -scan_for_includes ./src/sim
import_files -fileset sim_1 -norecurse ./src/sim

set design_name 	$BD_name

if { [string equal $board PYNQZ2] == 0} {
		# Add ip repository
		#set_property  ip_repo_paths  ./src/ip_repo [current_project]
		#update_ip_catalog
	
		# Build the Block Design
		if { [string first $current_vivado_version "2018.1 2018.2"] != -1 } {
			source ./src/tcl/bd_ZC702.tcl
		} else {
			source ./src/tcl/bd_ZC702_v2.tcl
		}
	} else {
		# Add ip repository
		set_property  ip_repo_paths  ./src/ip_repo [current_project]
		update_ip_catalog
		
		# Build the Block Design
		if { [string first $current_vivado_version "2018.1 2018.2"] != -1 } {
			source ./src/tcl/bd_PYNQZ2.tcl
		} else {
			source ./src/tcl/bd_PYNQZ2_v2.tcl
		}
	
	}
	
# Validate the BD
regenerate_bd_layout
#validate_bd_design 
save_bd_design

#Generate the wrapper
#make_wrapper -files [get_files ${BD_name}.bd] -top

# Add the wrapper to the fileset
#set obj [get_filesets sources_1]
#set files [list "[file normalize [glob "./$project_name/$project_name.srcs/sources_1/bd/$BD_name/hdl/${BD_name}_wrapper.v"]]"]
#add_files -norecurse -fileset $obj $files

# Generate the output products
#generate_target all [get_files ./$project_name/$project_name.srcs/sources_1/bd/$BD_name/${BD_name}.bd]
#create_ip_run [get_files -of_objects [get_fileset sources_1] ./$project_name/$project_name.srcs/sources_1/bd/$BD_name/${BD_name}.bd]
#launch_runs -jobs 8 [get_runs $BD_name*synth_1]
