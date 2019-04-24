// ============================================================================
// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Thu Jul 11 11:26:45 2013
// ============================================================================

`define ENABLE_ADC
`define ENABLE_AUD
`define ENABLE_CLOCK2
`define ENABLE_CLOCK3
`define ENABLE_CLOCK4
`define ENABLE_CLOCK
`define ENABLE_DRAM
`define ENABLE_FAN
`define ENABLE_FPGA
`define ENABLE_GPIO
`define ENABLE_HEX
//`define ENABLE_HPS
`define ENABLE_IRDA
`define ENABLE_KEY
`define ENABLE_LEDR
`define ENABLE_PS2
`define ENABLE_SW
`define ENABLE_TD
`define ENABLE_VGA

`define BBB_BOARD
//`define CPU

module bf_time_pcm_de1_soc(

      /* Enables ADC - 3.3V */
	`ifdef ENABLE_ADC

      output             ADC_CONVST,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

	`endif

       /* Enables AUD - 3.3V */
	`ifdef ENABLE_AUD

      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

	`endif

      /* Enables CLOCK2  */
	`ifdef ENABLE_CLOCK2
      input              CLOCK2_50,
	`endif

      /* Enables CLOCK3 */
	`ifdef ENABLE_CLOCK3
      input              CLOCK3_50,
	`endif

      /* Enables CLOCK4 */
	`ifdef ENABLE_CLOCK4
      input              CLOCK4_50,
	`endif

      /* Enables CLOCK */
	`ifdef ENABLE_CLOCK
      input              CLOCK_50,
	`endif

       /* Enables DRAM - 3.3V */
	`ifdef ENABLE_DRAM
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,
	`endif

      /* Enables FAN - 3.3V */
	`ifdef ENABLE_FAN
      output             FAN_CTRL,
	`endif

      /* Enables FPGA - 3.3V */
	`ifdef ENABLE_FPGA
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,
	`endif

      /* Enables GPIO - 3.3V */
	`ifdef ENABLE_GPIO
      inout     [35:0]         GPIO_0,
      inout     [35:0]         GPIO_1,
	`endif
 

      /* Enables HEX - 3.3V */
	`ifdef ENABLE_HEX
      output      [6:0]  HEX0,
      output      [6:0]  HEX1,
      output      [6:0]  HEX2,
      output      [6:0]  HEX3,
      output      [6:0]  HEX4,
      output      [6:0]  HEX5,
	`endif
	
	/* Enables HPS */
	`ifdef ENABLE_HPS
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N, //1.5V
      output             HPS_DDR3_CK_P, //1.5V
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_I2C2_SCLK,
      inout              HPS_I2C2_SDAT,
      inout              HPS_I2C_CONTROL,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif 

      /* Enables IRDA - 3.3V */
	`ifdef ENABLE_IRDA
      input              IRDA_RXD,
      output             IRDA_TXD,
	`endif

      /* Enables KEY - 3.3V */
	`ifdef ENABLE_KEY
      input       [3:0]  KEY,
	`endif

      /* Enables LEDR - 3.3V */
	`ifdef ENABLE_LEDR
      output      [9:0]  LEDR,
	`endif

      /* Enables PS2 - 3.3V */
	`ifdef ENABLE_PS2
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,
	`endif

      /* Enables SW - 3.3V */
	`ifdef ENABLE_SW
      input       [9:0]  SW,
	`endif

      /* Enables TD - 3.3V */
	`ifdef ENABLE_TD
      input             TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output            TD_RESET_N,
      input             TD_VS,
	`endif

      /* Enables VGA - 3.3V */
	`ifdef ENABLE_VGA
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
	`endif
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire reset_n;
wire clk_main;
wire clk_fast;
wire clk_200;
wire clk_dec;
wire clk_dec16;
wire clk_nco;
wire enable_clk_dec;
wire enable_clk_dec16;
wire [31:0] pdm_data_A;
wire [31:0] pdm_data_B;
wire [39:0] pdm_data;
wire pdm_clock;
wire pulse_lr;
wire ipt_mic_enable;  
wire [1:0] ipt_pdm_data_inp;
wire [31:0] led_export;
wire [9:0]  sw_export;
wire audio_ext_valid;
wire audio_ext_clock_en;
wire [15:0] audio_ext_data;
wire [1:0] pwm_out_export;

//=======================================================
//  LOCAL PARAMETERS
//=======================================================

localparam NCO_PHI_INC = 32'd89478485; // phi_inc = fo*2^32/fclk; fo=1KHz

// ==============================
//  DE1-SOC SPECIFIC ASSIGNMENTS
// ==============================

assign clk_main = CLOCK_50;
//assign reset_n = KEY[0];
assign reset_n = 1'b1;

// ==============================
//       BEAMFORMING BOARD 
// ==============================

// Clock
assign GPIO_0[16] = pdm_clock;    

`ifdef BBB_BOARD

// Black Beaglebone Board Adapter
bbb_array_adapter #(
 .NUM_ROWS (5),
 .NUM_COLS (8)
) bbb_array_adapter (
  .clk                    (clk_fast),
  .reset_n                (reset_n),

  .lr_sel                 (1'b1),
  
  .pulse_lr               (pulse_lr),
  .cnt_step               (SW[2:0]),
  .pdm_clk                (pdm_clock),
  .pdm_inp                (GPIO_0[4:0]),
  
  .adapter_sel_ff         (GPIO_0[7:5]),
  .adapter_out_ff         (pdm_data)
);

//assign GPIO_0[7:5] = SW[2:0];
//assign LEDR[2:0] = SW[2:0];

`else

// MIC_CLK <- JP1 (PIN: 19 , GPIO_0: 16) 
// MIC 1   -> JP1 (PIN: 5  , GPIO_0: 4) 
// MIC 2   -> JP1 (PIN: 7  , GPIO_0: 6) 
// MIC 3   -> JP1 (PIN: 9  , GPIO_0: 8) 
// MIC 4   -> JP1 (PIN: 13 , GPIO_0: 10)
// MIC 5   -> JP1 (PIN: 15 , GPIO_0: 12)
// MIC 6   -> JP1 (PIN: 17 , GPIO_0: 14)
// MIC 7   -> JP1 (PIN: 23 , GPIO_0: 20)
// MIC 8   -> JP1 (PIN: 25 , GPIO_0: 22)
// MIC 9   -> JP1 (PIN: 27 , GPIO_0: 24)
// MIC 10  -> JP1 (PIN: 31 , GPIO_0: 26)
// MIC 11  -> JP1 (PIN: 33 , GPIO_0: 28)
// MIC 12  -> JP1 (PIN: 35 , GPIO_0: 30)
// MIC 13  -> JP1 (PIN: 37 , GPIO_0: 32)
// MIC 14  -> JP1 (PIN: 39 , GPIO_0: 34)
// MIC 15  -> JP1 (PIN: 2  , GPIO_0: 1) 
// MIC 16  -> JP1 (PIN: 4  , GPIO_0: 3) 
// MIC 17  -> JP1 (PIN: 6  , GPIO_0: 5) 
// MIC 18  -> JP1 (PIN: 8  , GPIO_0: 7) 
// MIC 19  -> JP1 (PIN: 10 , GPIO_0: 9) 
// MIC 20  -> JP1 (PIN: 14 , GPIO_0: 11)
// MIC 21  -> JP1 (PIN: 16 , GPIO_0: 13)
// MIC 22  -> JP1 (PIN: 18 , GPIO_0: 15)
// MIC 23  -> JP1 (PIN: 20 , GPIO_0: 17)
// MIC 24  -> JP1 (PIN: 22 , GPIO_0: 19)
// MIC 25  -> JP1 (PIN: 24 , GPIO_0: 21)
// MIC 26  -> JP1 (PIN: 26 , GPIO_0: 23)
// MIC 27  -> JP1 (PIN: 28 , GPIO_0: 25)
// MIC 28  -> JP1 (PIN: 32 , GPIO_0: 27)
// MIC 29  -> JP1 (PIN: 34 , GPIO_0: 29)
// MIC 30  -> JP1 (PIN: 36 , GPIO_0: 31)
// MIC 31  -> JP1 (PIN: 38 , GPIO_0: 33)
// MIC 32  -> JP1 (PIN: 40 , GPIO_0: 35)
//
// MIC 33  -> JP2 (PIN: 5  , GPIO_1: 4) 
// MIC 34  -> JP2 (PIN: 7  , GPIO_1: 6) 
// MIC 35  -> JP2 (PIN: 9  , GPIO_1: 8) 
// MIC 36  -> JP2 (PIN: 13 , GPIO_1: 10)
// MIC 37  -> JP2 (PIN: 15 , GPIO_1: 12)
// MIC 38  -> JP2 (PIN: 17 , GPIO_1: 14)
// MIC 39  -> JP2 (PIN: 23 , GPIO_1: 20)
// MIC 40  -> JP2 (PIN: 25 , GPIO_1: 22)
// MIC 41  -> JP2 (PIN: 27 , GPIO_1: 24)
// MIC 42  -> JP2 (PIN: 31 , GPIO_1: 26)
// MIC 43  -> JP2 (PIN: 33 , GPIO_1: 28)
// MIC 44  -> JP2 (PIN: 35 , GPIO_1: 30)
// MIC 45  -> JP2 (PIN: 37 , GPIO_1: 32)
// MIC 46  -> JP2 (PIN: 39 , GPIO_1: 34)
// MIC 47  -> JP2 (PIN: 2  , GPIO_1: 1) 
// MIC 48  -> JP2 (PIN: 4  , GPIO_1: 3) 
// MIC 49  -> JP2 (PIN: 6  , GPIO_1: 5) 
// MIC 50  -> JP2 (PIN: 8  , GPIO_1: 7) 
// MIC 51  -> JP2 (PIN: 10 , GPIO_1: 9) 
// MIC 52  -> JP2 (PIN: 14 , GPIO_1: 11)
// MIC 53  -> JP2 (PIN: 16 , GPIO_1: 13)
// MIC 54  -> JP2 (PIN: 18 , GPIO_1: 15)
// MIC 55  -> JP2 (PIN: 20 , GPIO_1: 17)
// MIC 56  -> JP2 (PIN: 22 , GPIO_1: 19)
// MIC 57  -> JP2 (PIN: 24 , GPIO_1: 21)
// MIC 58  -> JP2 (PIN: 26 , GPIO_1: 23)
// MIC 59  -> JP2 (PIN: 28 , GPIO_1: 25)
// MIC 60  -> JP2 (PIN: 32 , GPIO_1: 27)
// MIC 61  -> JP2 (PIN: 34 , GPIO_1: 29)
// MIC 62  -> JP2 (PIN: 36 , GPIO_1: 31)
// MIC 63  -> JP2 (PIN: 38 , GPIO_1: 33)
// MIC 64  -> JP2 (PIN: 40 , GPIO_1: 35)

// MIC_A HEADER (JP1) indexes
reg [5:0] MIC_A [0:31] = '{  4,  6,  8, 10, 12, 14, 20, 22, 
                            24, 26, 28, 30, 32, 34,  1,  3,  
                             5,  7,  9, 11, 13, 15, 17, 19,  
                            21, 23, 25, 27, 29, 31, 33, 35  };  

// MIC_B HEADER (JP2) indexes
reg [5:0] MIC_B [0:31] = '{  4,  6,  8, 10, 12, 14, 20, 22, 
                            24, 26, 28, 30, 32, 34,  1,  3,  
                             5,  7,  9, 11, 13, 15, 17, 19,  
                            21, 23, 25, 27, 29, 31, 33, 35  };  

// Data
assign pdm_data_A[0]   = GPIO_0[MIC_A[0]]; 
assign pdm_data_A[1]   = GPIO_0[MIC_A[1]]; 
assign pdm_data_A[2]   = GPIO_0[MIC_A[2]]; 
assign pdm_data_A[3]   = GPIO_0[MIC_A[3]]; 
assign pdm_data_A[4]   = GPIO_0[MIC_A[4]]; 
assign pdm_data_A[5]   = GPIO_0[MIC_A[5]]; 
assign pdm_data_A[6]   = GPIO_0[MIC_A[6]]; 
assign pdm_data_A[7]   = GPIO_0[MIC_A[7]]; 
assign pdm_data_A[8]   = GPIO_0[MIC_A[8]]; 
assign pdm_data_A[9]   = GPIO_0[MIC_A[9]]; 
assign pdm_data_A[10]  = GPIO_0[MIC_A[10]]; 
assign pdm_data_A[11]  = GPIO_0[MIC_A[11]]; 
assign pdm_data_A[12]  = GPIO_0[MIC_A[12]]; 
assign pdm_data_A[13]  = GPIO_0[MIC_A[13]]; 
assign pdm_data_A[14]  = GPIO_0[MIC_A[14]]; 
assign pdm_data_A[15]  = GPIO_0[MIC_A[15]]; 
assign pdm_data_A[16]  = GPIO_0[MIC_A[16]]; 
assign pdm_data_A[17]  = GPIO_0[MIC_A[17]]; 
assign pdm_data_A[18]  = GPIO_0[MIC_A[18]]; 
assign pdm_data_A[19]  = GPIO_0[MIC_A[19]]; 
assign pdm_data_A[20]  = GPIO_0[MIC_A[20]]; 
assign pdm_data_A[21]  = GPIO_0[MIC_A[21]]; 
assign pdm_data_A[22]  = GPIO_0[MIC_A[22]]; 
assign pdm_data_A[23]  = GPIO_0[MIC_A[23]]; 
assign pdm_data_A[24]  = GPIO_0[MIC_A[24]]; 
assign pdm_data_A[25]  = GPIO_0[MIC_A[24]]; 
assign pdm_data_A[26]  = GPIO_0[MIC_A[26]]; 
assign pdm_data_A[27]  = GPIO_0[MIC_A[27]]; 
assign pdm_data_A[28]  = GPIO_0[MIC_A[28]]; 
assign pdm_data_A[29]  = GPIO_0[MIC_A[29]]; 
assign pdm_data_A[30]  = GPIO_0[MIC_A[30]]; 
assign pdm_data_A[31]  = GPIO_0[MIC_A[31]]; 

assign pdm_data_B[0]   = GPIO_1[MIC_B[0]]; 
assign pdm_data_B[1]   = GPIO_1[MIC_B[1]]; 
assign pdm_data_B[2]   = GPIO_1[MIC_B[2]]; 
assign pdm_data_B[3]   = GPIO_1[MIC_B[3]]; 
assign pdm_data_B[4]   = GPIO_1[MIC_B[4]]; 
assign pdm_data_B[5]   = GPIO_1[MIC_B[5]]; 
assign pdm_data_B[6]   = GPIO_1[MIC_B[6]]; 
assign pdm_data_B[7]   = GPIO_1[MIC_B[7]]; 
assign pdm_data_B[8]   = GPIO_1[MIC_B[8]]; 
assign pdm_data_B[9]   = GPIO_1[MIC_B[9]]; 
assign pdm_data_B[10]  = GPIO_1[MIC_B[10]]; 
assign pdm_data_B[11]  = GPIO_1[MIC_B[11]]; 
assign pdm_data_B[12]  = GPIO_1[MIC_B[12]]; 
assign pdm_data_B[13]  = GPIO_1[MIC_B[13]]; 
assign pdm_data_B[14]  = GPIO_1[MIC_B[14]]; 
assign pdm_data_B[15]  = GPIO_1[MIC_B[15]]; 
assign pdm_data_B[16]  = GPIO_1[MIC_B[16]]; 
assign pdm_data_B[17]  = GPIO_1[MIC_B[17]]; 
assign pdm_data_B[18]  = GPIO_1[MIC_B[18]]; 
assign pdm_data_B[19]  = GPIO_1[MIC_B[19]]; 
assign pdm_data_B[20]  = GPIO_1[MIC_B[20]]; 
assign pdm_data_B[21]  = GPIO_1[MIC_B[21]]; 
assign pdm_data_B[22]  = GPIO_1[MIC_B[22]]; 
assign pdm_data_B[23]  = GPIO_1[MIC_B[23]]; 
assign pdm_data_B[24]  = GPIO_1[MIC_B[24]]; 
assign pdm_data_B[25]  = GPIO_1[MIC_B[24]]; 
assign pdm_data_B[26]  = GPIO_1[MIC_B[26]]; 
assign pdm_data_B[27]  = GPIO_1[MIC_B[27]]; 
assign pdm_data_B[28]  = GPIO_1[MIC_B[28]]; 
assign pdm_data_B[29]  = GPIO_1[MIC_B[29]]; 
assign pdm_data_B[30]  = GPIO_1[MIC_B[30]]; 
assign pdm_data_B[31]  = GPIO_1[MIC_B[31]]; 

assign pdm_data = SW[0] ? pdm_data_B:  pdm_data_A;

`endif

// =============
//   SYSTEM 
// =============
`ifdef CPU
bf_time_pcm bf_time_pcm (
  .clk_50_clk                         (clk_main),
  .clk_100_clk                        (clk_fast),
  .reset_50_reset_n                   (reset_n),
  .reset_100_reset_n                  (reset_n),
  .mic_if_pdm_if_pdm_data             (pdm_data),
  .mic_if_pdm_if_pdm_clk_ff           (pdm_clock),
  .mic_if_pdm_if_pulse_lr             (pulse_lr),
  .mic_if_avalon_st_fil_error         (),
  .mic_if_avalon_st_fil_data          (),
  .mic_if_avalon_st_fil_valid         (),
  .mic_if_avalon_st_fil_startofpacket (),
  .mic_if_avalon_st_fil_endofpacket   (),
  .mic_if_avalon_st_fil_ready         (1'b1),
  .mic_if_avalon_st_pdm_error         (),
  .mic_if_avalon_st_pdm_data          (),
  .mic_if_avalon_st_pdm_valid         (),
  .mic_if_avalon_st_pdm_endofpacket   (),
  .mic_if_avalon_st_pdm_startofpacket (),
  .mic_if_avalon_st_pdm_ready         (1'b1),
  .mic_if_test_pdm_data_inp           (ipt_pdm_data_inp),
  .mic_if_test_mic_enable             (ipt_mic_enable),
  .mic_if_system_clk_dec              (clk_dec),
  .mic_if_system_clk_dec16            (clk_dec16),
  .mic_if_system_enable_clk_dec       (enable_clk_dec),
  .mic_if_system_enable_clk_dec16     (enable_clk_dec16),
  .audio_if_adcdat                    (AUD_ADCDAT),
  .audio_if_adclrc                    (AUD_ADCLRCK),
  .audio_if_bclk                      (AUD_BCLK),
  .audio_if_dacdat                    (AUD_DACDAT),
  .audio_if_daclrc                    (AUD_DACLRCK),
  .audio_ext_valid                    (audio_ext_valid),
  .audio_ext_clock_en                 (audio_ext_clock_en),
  .audio_ext_data                     (audio_ext_data),
  .led_export                         (led_export),
  .key_export                         (KEY),
  .sw_export                          (SW),
  .seg7_export                        ({HEX5P, HEX5, HEX4P, HEX4, 
                                        HEX3P, HEX3, HEX2P, HEX2,
                                        HEX1P, HEX1, HEX0P, HEX0}),
  .i2c_scl_export                     (FPGA_I2C_SCLK),
  .i2c_sda_export                     (FPGA_I2C_SDAT),
  .sdram_wire_addr                    (DRAM_ADDR),
  .sdram_wire_ba                      (DRAM_BA),
  .sdram_wire_cas_n                   (DRAM_CAS_N),
  .sdram_wire_cke                     (DRAM_CKE),
  .sdram_wire_cs_n                    (DRAM_CS_N),
  .sdram_wire_dq                      (DRAM_DQ),
  .sdram_wire_dqm                     ({DRAM_UDQM,DRAM_LDQM}),
  .sdram_wire_ras_n                   (DRAM_RAS_N),
  .sdram_wire_we_n                    (DRAM_WE_N),
  .pwm_out_export                     (pwm_out_export)
);
`else
bf_time_pcm bf_time_pcm (
  .clk_50_clk                         (clk_main),
  .clk_100_clk                        (clk_fast),
  .reset_50_reset_n                   (reset_n),
  .reset_100_reset_n                  (reset_n),
  .mic_if_pdm_if_pdm_data             (pdm_data), 
  .mic_if_pdm_if_pdm_clk_ff           (pdm_clock),
  .mic_if_pdm_if_pulse_lr             (pulse_lr),
  .mic_if_avalon_st_fil_error         (),
  .mic_if_avalon_st_fil_data          (),
  .mic_if_avalon_st_fil_valid         (),
  .mic_if_avalon_st_fil_startofpacket (),
  .mic_if_avalon_st_fil_endofpacket   (),
  .mic_if_avalon_st_fil_ready         (1'b1),
  .mic_if_avalon_st_pdm_error         (),
  .mic_if_avalon_st_pdm_data          (),
  .mic_if_avalon_st_pdm_valid         (),
  .mic_if_avalon_st_pdm_endofpacket   (),
  .mic_if_avalon_st_pdm_startofpacket (),
  .mic_if_avalon_st_pdm_ready         (1'b1),
  .mic_if_test_pdm_data_inp           (ipt_pdm_data_inp),
  .mic_if_test_mic_enable             (ipt_mic_enable),
  .mic_if_system_clk_dec              (clk_dec),
  .mic_if_system_clk_dec16            (clk_dec16),
  .mic_if_system_enable_clk_dec       (enable_clk_dec),
  .mic_if_system_enable_clk_dec16     (enable_clk_dec16),
  .audio_if_adcdat                    (AUD_ADCDAT),
  .audio_if_adclrc                    (AUD_ADCLRCK),
  .audio_if_bclk                      (AUD_BCLK),
  .audio_if_dacdat                    (AUD_DACDAT),
  .audio_if_daclrc                    (AUD_DACLRCK),
  .audio_ext_valid                    (audio_ext_valid),
  .audio_ext_clock_en                 (audio_ext_clock_en),
  .audio_ext_data                     (audio_ext_data),
  .led_export                         (led_export),
  .key_export                         (KEY),
  .sw_export                          (SW),
  .seg7_export                        ({HEX5P, HEX5, HEX4P, HEX4, 
                                        HEX3P, HEX3, HEX2P, HEX2,
                                        HEX1P, HEX1, HEX0P, HEX0}),
  .i2c_scl_export                     (FPGA_I2C_SCLK),
  .i2c_sda_export                     (FPGA_I2C_SDAT),
  .pwm_out_export                     (pwm_out_export)
);
`endif

// ================
//   CLOCK GATING
// ================
ALTCLKCTRL clk_gate_dec (
  .inclk  (clk_main),         
  .ena    (enable_clk_dec),   
  .outclk (clk_dec)           
);

ALTCLKCTRL clk_gate_dec16 (
  .inclk  (clk_main),         
  .ena    (enable_clk_dec16), 
  .outclk (clk_dec16)         
);

ALTCLKCTRL clk_gate_nco (
  .inclk  (!AUD_BCLK),         
  .ena    (audio_ext_clock_en), 
  .outclk (clk_nco)         
);

// ================
//      PLL
// ================
ALT_PLL alt_pll (
  .refclk   (CLOCK_50),   //  refclk.clk
  .rst      (!reset_n),   //  reset.reset
  .outclk_0 (clk_fast),   //  outclk0.clk
  .outclk_1 (clk_200),    //  outclk1.clk
  .outclk_2 (DRAM_CLK),   //  outclk1.clk
  .locked   ()            //  locked.export
);

// ================
//    AUDIO PLL 
// ================
ALT_PLL_AUDIO alt_pll_audio (
  .refclk   (CLOCK_50),   //  refclk.clk
  .rst      (!reset_n),   //  reset.reset
  .outclk_0 (AUD_XCK),    //  outclk0.clk
  .locked   ()            //  locked.export
);

// ================
//      NCO 
// ================
ALT_NCO alt_nco (
  .clk       (clk_nco),             // clk.clk
  .clken     (1'b1),                // in.clken
  .phi_inc_i (NCO_PHI_INC),         // phi_inc_i
  .fsin_o    (audio_ext_data),      // out.fsin_o
  .out_valid (audio_ext_valid),     // out_valid
  .reset_n   (reset_n)              // rst.reset_n
);

// ================
//       PWM 
// ================

assign GPIO_1[25:24] = pwm_out_export[1:0];

// ================
//       LED 
// ================

//assign LEDR[9:0] = led_export[9:0];
assign LEDR[9:3] = led_export[9:3];

endmodule
