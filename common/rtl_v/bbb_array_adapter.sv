// =============================================================================
// FILE: bbb_array_adapter.sv
// DATE: 24-Jan-2019
// AUTHOR: Sammy Carbajal
// =============================================================================
// PURPOSE: 
//   Adapter for Black Beaglebone's Microphone Array Shield
// =============================================================================
// PARAMETERS: 
//   NAME              DEFAULT  DESCRIPTION       
//   NUM_ROWS 		5 	 Number of rows
//   NUM_COLS 		8 	 Number of columns
//   SEL_WIDTH 		3 	 Selector width
// =============================================================================
module bbb_array_adapter #(
  parameter NUM_ROWS  = 5,
  parameter NUM_COLS  = 8,
  parameter SEL_WIDTH = $clog2(NUM_COLS)
)(
  input                 clk,
  input                 reset_n,

  input 		lr_sel,
  
  input                 pulse_lr,
  input                 pdm_clk,
  input [NUM_ROWS-1:0]  pdm_inp, 
  input [2:0]           cnt_step,
  
  output logic [SEL_WIDTH-1:0]         	    adapter_sel_ff,
  output logic [NUM_COLS-1:0][NUM_ROWS-1:0] adapter_out_ff
);

// Internal signals
logic [SEL_WIDTH:0] cnt_ff;
logic [2:0] cnt2_ff;
logic cnt2_zro;

integer i;
logic cnt_rst;
logic cnt_max;
logic pulse_rst_ff;
logic pulse_rst;
logic [NUM_COLS-1:0][NUM_ROWS-1:0] channel_ff;

// Channel decode
always_comb
begin
  adapter_out_ff[3] = channel_ff[0];
  adapter_out_ff[2] = channel_ff[1];
  adapter_out_ff[1] = channel_ff[2];
  adapter_out_ff[0] = channel_ff[3];
  adapter_out_ff[7] = channel_ff[4];
  adapter_out_ff[6] = channel_ff[5];
  adapter_out_ff[5] = channel_ff[6];
  adapter_out_ff[4] = channel_ff[7];
end

// Output registered
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n)
    channel_ff  <= 'd0; 
  else
    for (i = 0; i < NUM_COLS; i=i+1)
      if (cnt_ff == i & cnt2_zro)
        channel_ff[i] <= pdm_inp;

// Counter
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n)
    cnt_ff <= NUM_COLS;
  else if (cnt_rst)
    cnt_ff <= NUM_COLS-1;
  else if (!cnt_max & cnt2_zro)
    cnt_ff <= cnt_ff - 1;

// Counter zero
assign cnt_max = cnt_ff >= NUM_COLS;

// Output
assign adapter_sel_ff = cnt_ff[2:0];

// Pulse reset
assign pulse_rst = pulse_lr & (lr_sel ? pdm_clk : !pdm_clk);

// Posedge detector
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n)
    pulse_rst_ff  <= 1'b0;
  else
    pulse_rst_ff  <= pulse_rst;

// Counter reset
assign cnt_rst = pulse_rst & !pulse_rst_ff;

// Counter 2
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n)
    cnt2_ff <= 0;
  else if (cnt_max)
    cnt2_ff <= cnt_step;
  else
    if (cnt2_zro)
    	cnt2_ff <= cnt_step;
    else
    	cnt2_ff <= cnt2_ff - 1;

// Counte 2 zero
assign cnt2_zro = &(~cnt2_ff);

endmodule
