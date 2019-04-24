onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/tb/bbb_array_adapter/clk
add wave -noupdate /top/tb/bbb_array_adapter/reset_n
add wave -noupdate /top/tb/bbb_array_adapter/lr_sel
add wave -noupdate /top/tb/bbb_array_adapter/pulse_lr
add wave -noupdate /top/tb/bbb_array_adapter/pdm_clk
add wave -noupdate /top/tb/bbb_array_adapter/pdm_inp
add wave -noupdate /top/tb/bbb_array_adapter/cnt_step
add wave -noupdate /top/tb/bbb_array_adapter/adapter_sel_ff
add wave -noupdate /top/tb/bbb_array_adapter/adapter_out_ff
add wave -noupdate -radix ufixed /top/tb/bbb_array_adapter/cnt_ff
add wave -noupdate -radix ufixed /top/tb/bbb_array_adapter/cnt2_ff
add wave -noupdate /top/tb/bbb_array_adapter/cnt2_zro
add wave -noupdate /top/tb/bbb_array_adapter/i
add wave -noupdate /top/tb/bbb_array_adapter/cnt_rst
add wave -noupdate /top/tb/bbb_array_adapter/cnt_max
add wave -noupdate /top/tb/bbb_array_adapter/pulse_rst_ff
add wave -noupdate /top/tb/bbb_array_adapter/pulse_rst
add wave -noupdate /top/tb/bbb_array_adapter/channel_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipg_hard_async_reset_b
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipg_clk
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipg_clk_dec
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipg_clk_dec16
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipg_enable_clk_dec
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipg_enable_clk_dec16
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/pulse_lr
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/pdm_clk_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/pdm_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_fil_error
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_fil_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_fil_valid
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_fil_sop
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_fil_eop
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_fil_ready
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_pdm_error
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_pdm_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_pdm_valid
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_pdm_sop
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_pdm_eop
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_pdm_ready
add wave -noupdate -radix sfixed {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/data_out}
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipt_mic_enable
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipt_pdm_data_inp
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/read
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/write
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/address
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/chipselect
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/byteenable
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/writedata
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/readdata
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/fftpts_out
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/data_mic
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/data_del_in
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/data_del_out
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/data_delay
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/data_mux
add wave -noupdate -expand /top/tb/bf_time_pcm_inst/mic_if/inp_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/data_pdm_mux
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/sum_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/sum_pdm_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/sum_data_mux
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/sum_data_sat
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/soft_reset
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ipg_clk_delay
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/local_source_fil_error
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/local_source_fil_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/clk_div_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/cic_osr_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/shiftr_num_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/ch_en_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/sat_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/dis_st_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/aud_st_dis_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/aud_st_sel_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/round_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/lr_sel_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/mic_enable_ff
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/mic_if/aud_data_int
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/new_sample
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/mic_if/source_aud_data
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_aud_valid
add wave -noupdate /top/tb/bf_time_pcm_inst/mic_if/source_aud_ready
add wave -noupdate /top/tb/bf_time_pcm_inst/data_format_adapter_0/in_ready
add wave -noupdate /top/tb/bf_time_pcm_inst/data_format_adapter_0/in_valid
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/data_format_adapter_0/in_data
add wave -noupdate /top/tb/bf_time_pcm_inst/data_format_adapter_0/out_ready
add wave -noupdate /top/tb/bf_time_pcm_inst/data_format_adapter_0/out_valid
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/data_format_adapter_0/out_data
add wave -noupdate /top/tb/bf_time_pcm_inst/data_format_adapter_0/clk
add wave -noupdate /top/tb/bf_time_pcm_inst/data_format_adapter_0/reset_n
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/av_sink_error
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/av_sink_data
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/av_sink_valid
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/av_sink_ready
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/clock
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/reset_n
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/read
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/write
add wave -noupdate -radix ufixed /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/address
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/chipselect
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/byteenable
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/writedata
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/readdata
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/waitrequest
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart_sender/state_ff
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/the_bf_time_pcm_avalon_st_jtag_jtag_uart_scfifo_w/the_bf_time_pcm_avalon_st_jtag_jtag_uart_sim_scfifo_w/fifo_FF
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/the_bf_time_pcm_avalon_st_jtag_jtag_uart_scfifo_w/the_bf_time_pcm_avalon_st_jtag_jtag_uart_sim_scfifo_w/r_dat
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/the_bf_time_pcm_avalon_st_jtag_jtag_uart_scfifo_w/the_bf_time_pcm_avalon_st_jtag_jtag_uart_sim_scfifo_w/wfifo_empty
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/the_bf_time_pcm_avalon_st_jtag_jtag_uart_scfifo_w/the_bf_time_pcm_avalon_st_jtag_jtag_uart_sim_scfifo_w/wfifo_used
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/the_bf_time_pcm_avalon_st_jtag_jtag_uart_scfifo_w/the_bf_time_pcm_avalon_st_jtag_jtag_uart_sim_scfifo_w/clk
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/the_bf_time_pcm_avalon_st_jtag_jtag_uart_scfifo_w/the_bf_time_pcm_avalon_st_jtag_jtag_uart_sim_scfifo_w/fifo_wdata
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/the_bf_time_pcm_avalon_st_jtag_jtag_uart_scfifo_w/the_bf_time_pcm_avalon_st_jtag_jtag_uart_sim_scfifo_w/fifo_wr
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_irq
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_readdata
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_waitrequest
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/dataavailable
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/readyfordata
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_address
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_chipselect
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_read_n
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_write_n
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/av_writedata
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/clk
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/rst_n
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/ac
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/activity
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_AE
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_AF
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_EF
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_FF
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_clear
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_rd
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_rdata
add wave -noupdate -radix hexadecimal /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_wdata
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/fifo_wr
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/ien_AE
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/ien_AF
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/ipen_AE
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/ipen_AF
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/pause_irq
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/r_dat
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/r_ena
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/r_val
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/rd_wfifo
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/read_0
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/rfifo_full
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/rfifo_used
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/rvalid
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/sim_r_ena
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/sim_t_dat
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/sim_t_ena
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/sim_t_pause
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/t_dat
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/t_dav
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/t_ena
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/t_pause
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/wfifo_empty
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/wfifo_used
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/woverflow
add wave -noupdate /top/tb/bf_time_pcm_inst/avalon_st_jtag/jtag_uart/wr_rfifo
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/data_inp}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/data_out}
add wave -noupdate -radix ufixed {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/shiftr_num}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/round}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/sat}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/ch_en}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/is_positive_sat}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/is_negative_sat}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/data_inp_shiftr}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/data_inp_shiftr_rd}
add wave -noupdate {/top/tb/bf_time_pcm_inst/mic_if/mic_ch[0]/mic_channel/mic_round_sat/data_out_sat}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {116033418 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 520
configure wave -valuecolwidth 114
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {10035 ns} {163447764 ps}
