// =============================================================================
// FILE: main.c
// AUTHOR: Sammy Carbajal
// =============================================================================
// PURPOSE: 
//   Time-domain beamformer system
// =============================================================================
// HUMAN MACHINE INTERFACE:
//   KEY[0]: Hardware reset.
//   SW[9]:  Enable Microphone Interface.
//   SW[8]:  Enable Audio CODEC.
//   SW[7]:  Enable PWM Controller. Operation keys:
//   SW[2]:  PWM Controller Debug Mode.
// 	       KEY[1]: Select channel (0 or 1).
// 	       KEY[2]: Right.
// 	       KEY[3]: Left.
//   SW[1]:  AUDIO CODEC Debug Mode.
//             KEY[1]: Select channel right or left.
//             KEY[2]: Channel number down.
//             KEY[3]: Channel number up.
//   SW[0]:  Microphone Array Test Sequence.
// =============================================================================
// CONFIGURATION:
//     SDRAM: used to store record audio signal
//     on-chip memory: used to store Nios II program
//     MIC_IF: used to interface with MEMS microphones.
//     PWM_CTRL: used to control servomotors.
// =============================================================================
// COMPATIBILiTY:
//     Quartus 16.0    - DE1_SoC Board
//     Quartus 13.0sp1 - DE3 Board (AUDIO CODEC not supported)
// =============================================================================

#include <stdio.h>
#include <io.h>
#include "system.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h" //IOWR_ALTERA_AVALON_PIO_DATA
#include "AUDIO_SUBSYS_HAL.h"
#include "AUDIO_HAL.h"
#include "LED.h"
#include "SEG7_HAL.h"
#include "MIC_IF_HAL.h"
#include "PWM_CTRL_HAL.h"
#include <math.h>

#ifdef DEBUG_APP
    #define APP_DEBUG(x)    DEBUG(x)
#else
    #define APP_DEBUG(x)
#endif

#define IORD_SW IORD_ALTERA_AVALON_PIO_DATA(SW_BASE)

#define LEFT_BUTTON     0x08
#define RIGHT_BUTTON    0x04
#define SELECT_BUTTON    0x02

#define TEST_MIC_ARRAY_SW      0x01
#define TEST_AUDIO_SUBSYS_SW   0x01<<1
#define TEST_PWM_CTRL_SW       0x01<<2

#define INIT_MIC_IF_SW         0x01<<9
#define INIT_AUDIO_SUBSYS_SW   0x01<<8
#define INIT_PWM_CTRL_SW       0x01<<7

#define MIC_IF_INIT_ENABLED          INIT_MIC_IF_SW & IORD_SW
#define AUDIO_SUBSYS_INIT_ENABLED    INIT_AUDIO_SUBSYS_SW & IORD_SW
#define PWM_CTRL_INIT_ENABLED        INIT_PWM_CTRL_SW & IORD_SW

#define PLAYRING_BUTTON 0x02
#define RECORD_BLOCK_SIZE   250    // ADC FIFO: 512 byte
#define PLAY_BLOCK_SIZE     250    // DAC FIFO: 512 byte
#define MAX_TRY_CNT         1024
#define USE_SDRAM_FOR_DATA
#define NUM_CH 		35
#define PWM_PERIOD 1000000             // 20ms @ 50MHz
#define PWM_STEP   0.002*PWM_PERIOD    // 20ms*0.005  = 0.1ms
#define PWM_MAX    0.125*PWM_PERIOD    // 20ms*0.125  = 2.5ms
#define PWM_MIN    0.025*PWM_PERIOD    // 20ms*0.025  = 0.5ms

#define MAX_S16 0x8000   // 2^15
#define NUM_PWR_SAMP 32  // 2^5
#define MAX_POWER MAX_S16*NUM_PWR_SAMP //2^20
#define MAX_POWER_SHIFT 20 //clog2(MAX_POWER) 
#define NUM_POWER_LEDS 10

#define MIC_TEST_TIME 2 // in seconds

#ifndef USE_SDRAM_FOR_DATA
    #define BUF_SAMPLE_NUM     (96000*5)  // 5 second @ 96K
#else
    #define BUF_SAMPLE_NUM     (2)  // 0.5 second @ 96K
#endif 

// ============================================
//              Function Prototypes 
// ============================================

void button_monitor_isr(void* context, alt_u32 id);
bool button_monitor_start(volatile alt_u32 *pPressedMask);

bool MIC_IF_enabled = FALSE;
bool AUDIO_SUBSYS_enabled = FALSE;
bool PWM_CTRL_enabled = FALSE;

// ============================================
//       Internal Function Implementation 
// ============================================

bool ui_is_test_pwm_ctrl_sw_enabled(void){
    bool bEnabled;
    bEnabled = (IORD(SW_BASE, 0) & TEST_PWM_CTRL_SW)?TRUE:FALSE;
    return bEnabled;      
}

void button_monitor_isr(void* context, alt_u32 id){
    volatile alt_u32* pPressedMask = (volatile alt_u32*)context;
    *pPressedMask |= IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE) & 0x0F;  // 4-button 
    
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE,0); 
}

bool button_monitor_start(volatile alt_u32 *pPressedMask){
    bool bSuccess = TRUE;
    // enable interrupt
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0x0F); // 4-button
    
    // Reset the edge catpure register
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE,0); 
    
    // register IRQ
    if (bSuccess && (alt_irq_register(KEY_IRQ, (void *)pPressedMask, button_monitor_isr) != 0)){
        printf("[SW-MONITOR]register button IRQ fail\r\n");
        bSuccess = FALSE;
    }
    
    return bSuccess;        
}

void switch_monitor_isr(void* context, alt_u32 id){
    volatile alt_u32* pPressedMask = (volatile alt_u32*)context;
    *pPressedMask |= IORD_ALTERA_AVALON_PIO_EDGE_CAP(SW_BASE) & 0x03FF;  // 4-switch 
    
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(SW_BASE,0); 
}

bool switch_monitor_start(volatile alt_u32 *pPressedMask){
    bool bSuccess = TRUE;
    // enable interrupt
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(SW_BASE, 0x03FF); // 4-switch
    
    // Reset the edge catpure register
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(SW_BASE,0); 
    
    // register IRQ
    if (bSuccess && (alt_irq_register(SW_IRQ, (void *)pPressedMask, switch_monitor_isr) != 0)){
        printf("[SW-MONITOR]register switch IRQ fail\r\n");
        bSuccess = FALSE;
    }
    
    return bSuccess;        
}

void MIC_IF_Init() {
    int i;
    for(i=0;i<NUM_CH;i++)
        MIC_IF_ChannelEnable(i);
    MIC_IF_Saturation(TRUE);
    MIC_IF_RoundOff(TRUE);
    MIC_IF_CICOSR(51);      // pdm_clk/f_out -1 (pdm_clk=2.5MHz, fout=48KHz)
    MIC_IF_ShiftRightOut(11);
    MIC_IF_ClockDivider(10); // pdm_clk = osc_clk/(2*(clk_div))(osc_clk = 50MHz, pdm_clk=2.5MHz) 
    MIC_IF_DisableAvalonST(TRUE);
    MIC_IF_Enable();
    printf("PDM Microphone Initialized\r\n");

    printf("[MIC_IF] CTRL_1: %#010x \n", MIC_IF_GET(MIC_IF_CTRL_1_REG_ADDR));
    printf("[MIC_IF] CTRL_2: %#010x \n", MIC_IF_GET(MIC_IF_CTRL_2_REG_ADDR));
    printf("[MIC_IF] CTRL_3: %#010x \n", MIC_IF_GET(MIC_IF_CTRL_3_REG_ADDR));
    printf("[MIC_IF] CTRL_4: %#010x \n", MIC_IF_GET(MIC_IF_CTRL_4_REG_ADDR));
    printf("[MIC_IF] STATUS: %#010x \n", MIC_IF_GET(MIC_IF_STATUS_REG_ADDR));

    for (i = 0; i< NUM_CH ; i++)
      printf("[MIC_IF] DATA_%d:  %#010x \n", i, MIC_IF_GetData(i));
}

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

bool PWM_CTRL_Init(void){
  bool bSuccess =  TRUE;

  PWM_CTRL_SetCounter(PWM_PERIOD-1); // @50MHz, 20ms period
  PWM_CTRL_SetChDuty(0, PWM_MIN); // @50MHz, 20ms period
  PWM_CTRL_SetChDuty(1, PWM_MIN); // @50MHz, 20ms period
  
  PWM_CTRL_SetChEnable(0x03); // Enable 2 channels

  return bSuccess;
}


bool init(void){
    bool bSuccess = TRUE;
    
    SEG7_Clear();

    if (AUDIO_SUBSYS_INIT_ENABLED) {
      if (!AUDIO_InitFunc(LINEOUT_PLAY, RATE_ADC48K_DAC48K)){
      //if (!AUDIO_InitFunc(EXTERNAL_PLAY, RATE_ADC48K_DAC48K)){
          printf("Audio Init Error\r\n");
          bSuccess = FALSE;
      }
      AUDIO_SUBSYS_enabled = TRUE;
      printf("Audio CODEC Init: Succesfull.\n\n");
    }

    if (PWM_CTRL_INIT_ENABLED) {
      while(!PWM_CTRL_Init());
      PWM_CTRL_enabled = TRUE;
      printf("PWM Controller Init: Succesfull.\n\n");
    }

    if (MIC_IF_INIT_ENABLED) {
      MIC_IF_Init();
      MIC_IF_enabled = TRUE;
      printf("Microphone Interface Init: Succesfull.\n\n");
    }
        
    return bSuccess;
}

const char szMenu[][512] = {
    "=========== TIME-DOMAIN BEAMFORMER SYSTEM =============\n",
    "Operation guide:\n",
    "  KEY[0]: Hardware reset\n"
    "  SW[9]:  Enable Microphone Interface\n"
    "  SW[8]:  Enable Audio CODEC\n"
    "  SW[7]:  Enable PWM Controller\n" 
    "  SW[2]:  PWM Controller Debug Mode\n"
    "            KEY[1]: Select channel (0 or 1)\n"
    "            KEY[2]: Right\n"
    "            KEY[3]: Left\n"
    "  SW[1]:  AUDIO CODEC Debug Mode\n"
    "            KEY[1]: Select channel right or left\n"
    "            KEY[2]: Channel number down\n"
    "            KEY[3]: Channel number up\n"
    "  SW[0]:  Microphone Array Test Sequence\n"
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

       //power += (ch_data >= 0) ? ch_data : -ch_data;
       power += ch_data * ch_data;
       
       show_power(ch_data);
       
       //SEG7_SignedInteger(ch_data);
       
       MIC_IF_ClearDataReady();

       cnt++;
    }

    //return power >> 17;
    return power >> 30;
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

  // Enable external MUX with NCO @ 1KHz
  AUDIO_ENABLE_EXT_MUX();

  for (ch_tested = 0; ch_tested < NUM_CH; ch_tested++) {
       
    SEG7_Integer(ch_tested);

    // Test high
    AUDIO_DacEnableSoftMute(FALSE);
   
    pwrh = 0;
    cnt = 0;

    while (cnt < MIC_TEST_TIME*10){ // 2s (20*100ms)

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

    while (cnt < MIC_TEST_TIME*10){ // 2s (20*100ms)

       pwrl_tmp = listen_100ms(ch_tested);
       pwrl += pwrl_tmp;

       //printf(" Mic %d, power low : %d\n", ch_tested, pwrl_tmp);

       cnt++;
    }

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

// ============================================
//               Main Function
// ============================================

int main()
{
    volatile alt_u32 button_mask=0;
    volatile alt_u32 switch_mask=0;
    bool bLeftPressed, bRightPressed, bSelectPressed;
    bool bChannelSelected = 0;

    bool bMicArrayTstEnabled = 0;
    bool bPwmCtrlTstEnabled = 0;
    bool bAudioSubsysTstEnabled = 0;
    bool bError = FALSE;

    alt_u32 *pBuf, data, try_cnt, buf_sample_size;

    alt_16 ch_right, ch_left, ch_mean;
    alt_16 ch_right_num = 0, ch_left_num = 0;

    alt_u32 duty_val = 0;
    
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

    button_monitor_start(&button_mask);  // button IRQ
    switch_monitor_start(&switch_mask);  // switch IRQ

    // infinite loop
    printf("Finished initialization.\n");

    while(1){
        bPwmCtrlTstEnabled = (TEST_PWM_CTRL_SW & IORD_SW)?TRUE:FALSE;
        bMicArrayTstEnabled = (switch_mask & TEST_MIC_ARRAY_SW & IORD_SW)?TRUE:FALSE;
        bAudioSubsysTstEnabled = (TEST_AUDIO_SUBSYS_SW & IORD_SW)?TRUE:FALSE;

	if(bMicArrayTstEnabled & MIC_IF_enabled){
          printf("\n============================================\n");
          printf("== Microphone Array Test Sequence (SW[0]) ==\n");
          printf("============================================\n");
    	  microphone_test();
	  switch_mask = 0;
	}
	else if (bAudioSubsysTstEnabled & AUDIO_SUBSYS_enabled & MIC_IF_enabled){
	  if (switch_mask & TEST_AUDIO_SUBSYS_SW){
             printf("\n============================================\n");
             printf("====== Audio CODEC Debug Mode (SW[1]) ======\n");
             printf("============================================\n");
             printf("Operation guide:\n");
             printf("  KEY[0]: Reset.\n");
             printf("  KEY[1]: Select channel right or left.\n");
             printf("  KEY[2]: Channel number down.\n");
             printf("  KEY[3]: Channel number up.\n");
             printf("============================================\n");
             printf("\n\n");
 	     // Disable external MUX 
  	     AUDIO_DISABLE_EXT_MUX();

	     switch_mask = 0;
	  }

          bLeftPressed = (button_mask & LEFT_BUTTON)?TRUE:FALSE;
          bRightPressed = (button_mask & RIGHT_BUTTON)?TRUE:FALSE;
          bSelectPressed = (button_mask & SELECT_BUTTON)?TRUE:FALSE;

	  if(bSelectPressed){
	    bChannelSelected = !bChannelSelected;
	    if (bChannelSelected)
	       printf("Channel Selected: Right / num: %d\n", ch_right_num);
	    else
	       printf("Channel Selected: Left / num: %d\n", ch_left_num);
		
	    button_mask = 0;
	  }

	  if(bLeftPressed){
	    if (bChannelSelected)
	      ch_right_num += 1;
	    else
	      ch_left_num += 1;

	    if (ch_right_num >= NUM_CH)
	       ch_right_num = 0;

	    if (ch_left_num >= NUM_CH)
	       ch_left_num = 0;

	    if (bChannelSelected)
	       printf("Right Channel: %d\n", ch_right_num);
	    else
	       printf("Left Channel: %d\n", ch_left_num);
	    button_mask = 0;
	  }

	  if(bRightPressed){
	    if (bChannelSelected)
	      ch_right_num -= 1;
	    else
	      ch_left_num -= 1;

	    if (ch_right_num < 0)
	       ch_right_num = NUM_CH-1;

	    if (ch_left_num < 0)
	       ch_left_num = NUM_CH-1;

	    if (bChannelSelected)
	       printf("Right Channel: %d\n", ch_right_num);
	    else
	       printf("Left Channel: %d\n", ch_left_num);
	    button_mask = 0;
	  }

	  try_cnt = 0;                
	  while (!AUDIO_DacFifoNotFull() && try_cnt < MAX_TRY_CNT){  // wait while full
	      try_cnt++;
	  }    

	  if (try_cnt >= MAX_TRY_CNT){
	      bError = TRUE;
	      printf("Error!.");
	      break;
	  }    

	  while(!MIC_IF_DataReady());
	  
	  ch_left  = MIC_IF_GetData(ch_left_num);	
	  ch_right = MIC_IF_GetData(ch_right_num);	

    	  //AUDIO_DacFifoSetData(ch_left, ch_right);  
    	  AUDIO_DacFifoSetData(ch_left, ch_left);  
	  ch_mean = (ch_left + ch_right)/2;

    	  show_power(ch_left);
    	  //show_power(ch_mean);

    	  SEG7_SignedInteger(ch_left);
    	  //SEG7_SignedInteger(ch_mean);
	
	  MIC_IF_ClearDataReady();
        }
	else if (bPwmCtrlTstEnabled & PWM_CTRL_enabled){
	  if (switch_mask & TEST_PWM_CTRL_SW){
             printf("\n============================================\n");
             printf("===== PWM Controller Debug Mode (SW[2]) ====\n");
             printf("============================================\n");
             printf("Operation guide:\n");
             printf("  KEY[0]: Reset.\n");
             printf("  KEY[1]: Select channel (0 or 1).\n");
             printf("  KEY[2]: Right.\n");
             printf("  KEY[3]: Left.\n");
             printf("============================================\n");
             printf("\n\n");
	     switch_mask = 0;
	  }

          bLeftPressed = (button_mask & LEFT_BUTTON)?TRUE:FALSE;
          bRightPressed = (button_mask & RIGHT_BUTTON)?TRUE:FALSE;
          bSelectPressed = (button_mask & SELECT_BUTTON)?TRUE:FALSE;

	  if(bSelectPressed){
	    bChannelSelected = !bChannelSelected;
	    printf("Channel Selected: %d\n", bChannelSelected);
	    button_mask = 0;
	  }

	  if(bLeftPressed){
	    duty_val = PWM_CTRL_GetChDuty(bChannelSelected);
	    duty_val += PWM_STEP;

	    if (duty_val >= PWM_MAX)
	       duty_val = PWM_MAX;
	    else if (duty_val <= PWM_MIN)
	       duty_val = PWM_MIN;

	    PWM_CTRL_SetChDuty(bChannelSelected, duty_val);
	    button_mask = 0;
	    printf("Left pressed\nduty_val:\t%d\n", duty_val);
	  }

	  if(bRightPressed){
	    duty_val = PWM_CTRL_GetChDuty(bChannelSelected);
	    duty_val -= PWM_STEP;

	    if (duty_val >= PWM_MAX)
	       duty_val = PWM_MAX;
	    else if (duty_val <= PWM_MIN)
	       duty_val = PWM_MIN;

	    PWM_CTRL_SetChDuty(bChannelSelected, duty_val);
	    button_mask = 0;
	    printf("Right pressed\nduty_val:\t%d\n", duty_val);
	  }
	}

    }
    
}
