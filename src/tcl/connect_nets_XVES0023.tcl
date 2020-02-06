
connect_bd_intf_net [get_bd_intf_pins *tpg*/m_axis_video] [get_bd_intf_pins *axi4s_vid_out_*/video_in]
connect_bd_intf_net [get_bd_intf_pins *axi4s_vid_out*/vtiming_in] [get_bd_intf_pins v_tc*/vtiming_out]
connect_bd_net [get_bd_pins v_axi4s_vid_out*/aclk] [get_bd_pins processing_system7_*/FCLK_CLK0]
connect_bd_net [get_bd_pins v_tpg*/ap_rst_n] [get_bd_pins *axi4s_vid_out_*/aresetn]
connect_bd_net [get_bd_pins v_axi4s_vid_out*/vtg_ce] [get_bd_pins v_tc*/gen_clken]
connect_bd_net [get_bd_pins v_axi4s_vid_out*/vid_io_out_clk] [get_bd_pins processing_system7_*/FCLK_CLK1]

