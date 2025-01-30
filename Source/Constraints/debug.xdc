set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]












create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list DRX_Rx_bd_i/PLL/inst/Clk_100MHz]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/video_buf_write_state[0][0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/video_buf_write_state[0][1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/video_buf_write_state[0][2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][2]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][3]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][4]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][5]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][6]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi[0][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][2]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][3]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][4]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][5]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][6]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_dout[0][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_full[0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_full[1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_full[2]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_full[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 4 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_rd_en[0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_rd_en[1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_rd_en[2]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_rd_en[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_wr_en[0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_wr_en[1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_wr_en[2]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/rssi_fifo_wr_en[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[0]} {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[1]} {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[2]} {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[3]} {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[4]} {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[5]} {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[6]} {DRX_Rx_bd_i/VIDEO_BUF_0/DATA_IN_0[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 12 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][2]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][3]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][4]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][5]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][6]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][7]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][8]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][9]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][10]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/last_rssi[0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 7 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0/U0/line_bytes_cnt[0][0]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/line_bytes_cnt[0][1]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/line_bytes_cnt[0][2]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/line_bytes_cnt[0][3]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/line_bytes_cnt[0][4]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/line_bytes_cnt[0][5]} {DRX_Rx_bd_i/VIDEO_BUF_0/U0/line_bytes_cnt[0][6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 12 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[0]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[1]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[2]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[3]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[4]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[5]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[6]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[7]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[8]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[9]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[10]} {DRX_Rx_bd_i/VIDEO_BUF_0_rssi_acc_0[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list DRX_Rx_bd_i/VIDEO_BUF_0/DATA_VALID_0]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
