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
  
  output logic [SEL_WIDTH-1:0]         	    adapter_sel_ff,
  output logic [NUM_COLS-1:0][NUM_ROWS-1:0] adapter_out_ff
);

// Internal signals
logic [NUM_COLS-1:0] enable_col;
logic [SEL_WIDTH:0] cnt_ff;

integer i;
logic cnt_rst;
logic pulse_rst_ff;
logic pulse_rst;

// Output registered
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n)
    adapter_out_ff  <= 'd0; 
  else
    for (i = 1; i <= NUM_COLS; i=i+1)
      if (cnt_ff == i)
        adapter_out_ff[i-1] <= pdm_inp;

// Counter
always_ff @(posedge clk, negedge reset_n)
  if (!reset_n)
    cnt_ff <= 'd0;
  else if (cnt_rst)
    cnt_ff <= NUM_COLS;
  else if (!cnt_zro)
    cnt_ff <= cnt_ff - 1;

// Counter zero
assign cnt_zro = &(~cnt_ff);

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

endmodule
