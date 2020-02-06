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
 # @file create_SW_proj.tcl
 #
 #	Tcl script for re-creating SDK workspace for Video Series 22
 # 
 #
###############################################################################


# Set SDK Workspace
sdk setws ./sdk_workspace

variable board
set default_board "ZC702 PYNQZ2"

if { [string first $board $default_board] == -1} {
		puts "$board is not supported. board supported are $default_board."
		puts "First set the board by running : set board ZC702 or set board PYNQZ2"
		puts "And after source the tcl file" 
		return -1
	}

if { [string equal $board PYNQZ2] == 0} {	
		# Create the HW platform
		sdk createhw -name hw_0 -hwspec ./sdk_export/ZC702_HDMI_wrapper.hdf

		#Create the BSP
		sdk createbsp -name tpg_hdmi_zc702_bsp -hwproject hw_0 -proc ps7_cortexa9_0 -os standalone
		sdk projects -build -type bsp -name tpg_hdmi_zc702_bsp

		#creating empty application
		sdk createapp -name tpg_hdmi_zc702_app -hwproject hw_0 -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp tpg_hdmi_zc702_bsp

		#importe the src files
		sdk importsources -name tpg_hdmi_zc702_app -path ./src/sdk/ZC702

		#build
		sdk projects -clean -type app -name tpg_hdmi_zc702_app
		sdk projects -build -type app -name tpg_hdmi_zc702_app
	} else {
		# Create the HW platform
		sdk createhw -name hw_0 -hwspec ./sdk_export/video_out_pynq_z2_wrapper.hdf

		#Create the BSP
		sdk createbsp -name tpg_video_out_pynq_z2_bsp -hwproject hw_0 -proc ps7_cortexa9_0 -os standalone
		sdk projects -build -type bsp -name tpg_video_out_pynq_z2_bsp

		#creating empty application
		sdk createapp -name video_out_pynq_z2_app -hwproject hw_0 -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp tpg_video_out_pynq_z2_bsp

		#importe the src files
		sdk importsources -name video_out_pynq_z2_app -path ./src/sdk/PYNQZ2

		#build
		sdk projects -clean -type app -name video_out_pynq_z2_app
		sdk projects -build -type app -name video_out_pynq_z2_app
	}	
	
	

exit
