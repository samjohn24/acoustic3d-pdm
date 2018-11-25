// --------------------------------------------------------------------
// Copyright (c) 2010 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
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
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------

/*
 * Function:
 *      Audio record and Play
 * 
 * Human Machine Interface:
 *      KEY3: Record Start/Stop (Auto Stop when buffer is full)
 *      KEY2: Play Start/Stop (Audo Stop when no data to play)
 *      SEG7: Display the duration of recording/playing
 *      LED:  Display the singal strength.
 *      SW0:  Audio Source Selection: DOWN-->MIC, UP-->LINE-IN
 *      SW1:  MIC Boost Control when audio source is MIC. DOWN-->BOOST OFF UP-->BOSST ON
 *      SW2:  Zero-Cross detect for Playing: DOWN-->OFF, UP-->ON
 *      SW5/SW4/SW3: Sample Rate Control: 
 *                    DOWN/DOWN/DOWN-->96K 
 *                    DOWN/DOWN/UP->48K,
 *                    DOWN/UP/DOWN->44.1K, 
 *                    DOWN/UP/UP->32K,
 *                    UP/DOWN/DOWN->8K
 * 
 * CONFIGURATION:
 *      SDRAM: used to store record audio signal
 *      on-chip memory: used to store Nios II program
 * 
 * Revision:
 *      V1.0, 11/21/2007, init by Richard.
 *      V1.01 21/5 /2010  
 * 
 * Compatibility:
 *      Quartus 13.0
 *      DE1_SoC Board
 */

//#include "my_includes.h"
#include <stdio.h>
#include <io.h>
#include "system.h"
#include "alt_types.h"
#include "AUDIO_SUBSYS_HAL.h"
#include "LED.h"
#include "SEG7_HAL.h"
#include "MIC_IF_HAL.h"
//#include "AUDIO_HAL.h"
#include <math.h>


#ifdef DEBUG_APP
    #define APP_DEBUG(x)    DEBUG(x)
#else
    #define APP_DEBUG(x)
#endif


///////////////////////////////////////////////////////////////////////////////
//////////// Internal function prototype & data structure /////////////////////
///////////////////////////////////////////////////////////////////////////////
//================= internal function prototype & data structure definit =====
#define RECORD_BUTTON   0x08
#define PLAY_BUTTON     0x04
#define PLAYRING_BUTTON 0x02
#define RECORD_BLOCK_SIZE   250    // ADC FIFO: 512 byte
#define PLAY_BLOCK_SIZE     250    // DAC FIFO: 512 byte
#define MAX_TRY_CNT         1024
#define USE_SDRAM_FOR_DATA
#define NUM_CH 		32

#define FFTPTS_1D  7 // 2^7 = 128

#ifndef USE_SDRAM_FOR_DATA
    #define BUF_SAMPLE_NUM     (96000*5)  // 5 second @ 96K
#else
    #define BUF_SAMPLE_NUM     (2)  // 0.5 second @ 96K
#endif 

# define MAX_S16 0x8000   // 2^15
# define NUM_PWR_SAMP 32  // 2^5
# define MAX_POWER MAX_S16*NUM_PWR_SAMP //2^20
# define MAX_POWER_SHIFT 20 //clog2(MAX_POWER) 
# define NUM_POWER_LEDS 10

//void button_monitor_isr(void* context, alt_u32 id);
//bool button_monitor_start(volatile alt_u32 *pPressedMask);
//bool init_audio(AUDIO_FUNC audio_func);
//void display_time_elapsed(alt_u32 sample_num);

// global variable
//int record_sample_rate;

/*
// ui config
bool ui_is_mic_boost(void);
bool ui_is_mic_record(void);
bool ui_is_dac_zero_cross(void);
int  ui_get_sample_rate(void);


///////////////////////////////////////////////////////////////////////////////
//////////// Internal function implement(body) ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
bool ui_is_mic_record(void){
    bool bMicRecord;
    bMicRecord = (IORD(SW_BASE, 0) & 0x01)?FALSE:TRUE;
    return bMicRecord;    
}

bool ui_is_mic_boost(void){
    bool bMicBoost;
    bMicBoost = (IORD(SW_BASE, 0) & (0x01 << 1))?TRUE:FALSE;
    return bMicBoost;    
}

bool ui_is_dac_zero_cross(void){
    bool bZeroCross;
    bZeroCross = (IORD(SW_BASE, 0) & (0x01 << 2))?TRUE:FALSE;
    return bZeroCross;      
}

int ui_get_sample_rate(void){
    int sample_rate = 96000;
    alt_u32 mask;
    mask = IORD(SW_BASE, 0);
    mask = (mask >> 3) & 0x07;
    if (mask == 1)
        sample_rate = 48000;
    else if (mask == 2)
        sample_rate = 44100;
    else if (mask == 3)
        sample_rate = 32000;
    else if (mask == 4)
        sample_rate = 8000;
    return sample_rate;      
} 
*/

//void button_monitor_isr(void* context, alt_u32 id){
//    volatile alt_u32* pPressedMask = (volatile alt_u32*)context;
//    *pPressedMask |= IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE) & 0x0F;  // 4-button 
//    
//    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE,0); 
//}

//bool button_monitor_start(volatile alt_u32 *pPressedMask){
//    bool bSuccess = TRUE;
//    // enable interrupt
//    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0x0F); // 4-button
//    
//    // Reset the edge catpure register
//    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE,0); 
//    
//    // register IRQ
//    if (bSuccess && (alt_irq_register(KEY_IRQ, (void *)pPressedMask, button_monitor_isr) != 0)){
//        printf("[SW-MONITOR]register button IRQ fail\r\n");
//        bSuccess = FALSE;
//    }
//    
//    return bSuccess;        
//}

void MIC_IF_Init() {
    int i;
    for(i=0;i<NUM_CH;i++)
        MIC_IF_ChannelEnable(i);
    MIC_IF_Saturation(TRUE);
    //MIC_IF_Saturation(FALSE);
    MIC_IF_RoundOff(TRUE);
    //MIC_IF_CICOSR(13);
    //MIC_IF_ShiftRightOut(0);
    MIC_IF_CICOSR(51);      // pdm_clk/f_out -1 (pdm_clk=2.5MHz, fout=48KHz)
    //MIC_IF_ShiftRightOut(10);
    MIC_IF_ShiftRightOut(11);
    //MIC_IF_ClockDivider(7);
    //MIC_IF_ClockDivider(39); // 2*(osc_clk/pdm_clk)-1 (osc_clk = 50MHz, pdm_clk=2.5MHz) 
    MIC_IF_ClockDivider(9); // pdm_clk = osc_clk/(2*(clk_div+1))(osc_clk = 50MHz, pdm_clk=2.5MHz) 
    MIC_IF_DisableAvalonST(TRUE);
    MIC_IF_Enable();
    //MIC_IF_ClearDataReady();
}



//void display_time_elapsed(alt_u32 sample_num){
//    // assume sample rate is 48K
//    alt_u32 time;
//    time = sample_num * 100 / record_sample_rate;
//    SEG7_Decimal(time, 0x04);
//}

void show_power(alt_16 sample){
    static alt_u32 sum = 0;
    static alt_u16   cnt = 0;
    alt_u16 power = 0;
    sum += (sample >= 0)?sample:-sample;
    cnt++;
    if (cnt == NUM_PWR_SAMP){
        power = (NUM_POWER_LEDS * sum) >> MAX_POWER_SHIFT;
        LED_LightCount(power); 
        sum = 0;
        cnt = 0;
    }
}


bool init(void){
    bool bSuccess = TRUE;
    
    SEG7_Clear();


    // prepare    
    if (!AUDIO_InitFunc(EXTERNAL_PLAY, RATE_ADC48K_DAC48K)){
    //if (!AUDIO_InitFunc(LINEOUT_PLAY, RATE_ADC48K_DAC48K)){
        printf("Audio Init Error\r\n");
        bSuccess = FALSE;
    }

    MIC_IF_Init();
    printf("PDM Microphone Initialized\r\n");
        
    return bSuccess;
}

//void dump_record_data(alt_u32 *pData, alt_u32 len){
//    short sample_l, sample_r, sample_max = 0;
//    alt_u32 data;
//    int i;
//    //return ;
//    for(i=0;i<len;i++){
//        data = *pData++;
//        sample_l = (short)((data >> 16) & 0xFFFF); 
//        sample_r = (short)(data & 0xFFFF);
//        //printf("[%d]%d/%d\n", i, sample_l, sample_r);
//        if (sample_l > 0 && sample_max <  sample_l)
//            sample_max = sample_l;
//        if (sample_l < 0 && sample_max <  -sample_l)
//            sample_max = -sample_l;
//        if (sample_r > 0 && sample_max <  sample_r)
//            sample_max = sample_r;
//        if (sample_r < 0 && sample_max <  -sample_r)
//            sample_max = -sample_r;
//    }
//    printf("max=%d\n", sample_max);
//}


const char szMenu[][128] = {
    "================ MIC_IF TEST ===============\n",
    "Operation guide:\n",
    "  KEY0: Reset.\n",
    "  Status Information:\n",    
    "  LED[7:0]:  Display audio singal strength.\n",
    "  LED[8]:  Display audio signal strength.\n",
    "  LED[9]:  Display if MIC_IF is running.\n",
    "\n\n"
};

void show_menu(void){
    int i;
    for(i=0;i<sizeof(szMenu)/sizeof(szMenu[0]);i++)
        printf(szMenu[i]);
}

alt_u32 listen_100ms (alt_u8 ch_tested) {
    alt_u16 cnt = 0;
    alt_u64 power = 0; 
    alt_16 ch_data;

    while (cnt < 4800){ // 2s (20*100e-3*48e3)

       while(!MIC_IF_DataReady());
       
       ch_data = (alt_16) MIC_IF_GetData(ch_tested);	

       power += (ch_data >= 0) ? ch_data : -ch_data;
       
       show_power(ch_data);
       
       //SEG7_SignedInteger(ch_data);
       
       MIC_IF_ClearDataReady();

       cnt++;
    }

    return power >> 17;
}



void microphone_test(void){
  alt_u64 pwrh;
  alt_u64 pwrh_tmp;
  alt_u64 pwrl;
  alt_u64 pwrl_tmp;
  alt_u8 cnt;
  alt_u8 ch_tested;
  bool ch_status[NUM_CH];
  alt_u8 ch_ok = 0;


  for (ch_tested = 0; ch_tested < NUM_CH; ch_tested++) {
       
    SEG7_Integer(ch_tested);

    // Test high
    AUDIO_DacEnableSoftMute(FALSE);
   
    pwrh = 0;
    cnt = 0;

    while (cnt < 20){ // 2s (20*100ms)

       pwrh_tmp = listen_100ms(ch_tested);
       pwrh += pwrh_tmp;

       //printf(" Mic %d, power high : %d\n", ch_tested, pwrh_tmp);

       cnt++;
    }

    printf("\t Mic %d, power high : %d\n", ch_tested, pwrh);

    // Test low
    AUDIO_DacEnableSoftMute(TRUE);

    pwrl = 0;
    cnt = 0;

    while (cnt < 20){ // 2s (20*100ms)

       pwrl_tmp = listen_100ms(ch_tested);
       pwrl += pwrl_tmp;

       //printf(" Mic %d, power low : %d\n", ch_tested, pwrl_tmp);

       cnt++;
    }

    //AUDIO_DacEnableSoftMute(TRUE);
    printf("\t Mic %d, power low : %d\n", ch_tested, pwrl);

    // Result
    if (100*pwrh >= 105*pwrl){
	printf(" Mic %d: OK\n\n", ch_tested);
        ch_status[ch_tested] = TRUE;
        ch_ok++;
    } else {
	printf(" Mic %d: Fail\n\n", ch_tested);
        ch_status[ch_tested] = FALSE;
    }

  }
  AUDIO_DacEnableSoftMute(TRUE);
 
  printf("Total Mic OK: %d \n", ch_ok);
  printf("Mic OK list: ");
  
  for (ch_tested = 0; ch_tested < NUM_CH; ch_tested++) 
     if (ch_status[ch_tested])
       printf("%d, ", ch_tested);
  

}

int main()
{
    //typedef enum{
    //    ST_STANDY,
    //    ST_RECODING,
    //    ST_PLAYING
    //}STATE;
    //STATE state = ST_STANDY;
    //volatile alt_u32 button_mask=0;
    //bool bRecordPressed, bPlayPressed, bError = FALSE;
    bool bError = FALSE;
    alt_u32 *pBuf, data, try_cnt, buf_sample_size;
    //alt_u32 *pBuf, *pPlaying, *pRecording, RecordLen, PlayLen, data, try_cnt, buf_sample_size;
    alt_16 ch_right, ch_left;
    //alt_u16 ch_right, ch_left;
    //alt_u32 energy_l, energy_h;
    //alt_u16 angle_factor;
    
    show_menu();    

    if (!init())
        return 0;
        
    
    #ifdef USE_SDRAM_FOR_DATA
        pBuf = (alt_u32 *)SDRAM_BASE;
        buf_sample_size = SDRAM_SPAN/sizeof(alt_u32);
    #else    
        // alloc memory to stroe PCM data 
        buf_sample_size = BUF_SAMPLE_NUM;
        pBuf = malloc(buf_sample_size * sizeof(alt_u32));
        if (!pBuf){
            //LCD_TextOut("malloc fail\n\n");
            printf("malloc fail\r\n");
            return 0;
        }
    #endif    

    //button_monitor_start(&button_mask);  // button IRQ
    printf("ready\n");
    
    
    // test
    //record_sample_rate = ui_get_sample_rate(); 
    //RecordLen = buf_sample_size;
    //
    //AUDIO_FifoClear();

    //pPlaying = pBuf;
    //PlayLen = 0;
    //angle_factor = 0;

    //AUDIO_DacEnableSoftMute(TRUE);



    printf("[MIC_IF] CTRL_1: %#010x \n", MIC_IF_GET(MIC_IF_CTRL_1_REG_ADDR));
    printf("[MIC_IF] CTRL_2: %#010x \n", MIC_IF_GET(MIC_IF_CTRL_2_REG_ADDR));
    printf("[MIC_IF] CTRL_3: %#010x \n", MIC_IF_GET(MIC_IF_CTRL_3_REG_ADDR));
    printf("[MIC_IF] STATUS: %#010x \n", MIC_IF_GET(MIC_IF_STATUS_REG_ADDR));


    int i;
    for (i = 0; i< NUM_CH ; i++)
      printf("[MIC_IF] DATA_%d:  %#010x \n", i, MIC_IF_GetData(i));
	
    // infinite loop
    printf("Finished initialization.\n");


    microphone_test();

    //AUDIO_DacEnableSoftMute(FALSE);


    while(1){
	
	//try_cnt = 0;                
	//while (!AUDIO_DacFifoNotFull() && try_cnt < MAX_TRY_CNT){  // wait while full
	//    try_cnt++;
	//}    
	//if (try_cnt >= MAX_TRY_CNT){
	//    bError = TRUE;
	//    printf("Play error!.");
	//    break;
	//}    

	while(!MIC_IF_DataReady());
	
	ch_left  = MIC_IF_GetData(5);	

    	//AUDIO_DacFifoSetData(ch_left, ch_left);  

    	show_power(ch_left);

	//printf("%d, %d \n", ch_left, ch_right);
    	//SEG7_SignedInteger(ch_left);
	
	//MIC_IF_ClearDataReady();

    }
    
}


    
