"""
 +FHDR-------------------------------------------------------------------------
 FILE NAME      : mic_if_hal.py
 AUTHOR         : Sammy Carbajal
 ------------------------------------------------------------------------------
 PURPOSE
  Hardware acelleration library for MIC_IF module using jtag_client.
 -FHDR-------------------------------------------------------------------------
"""
import numpy as np

class mic_if_hal:

    MIC_IF_CTRL_1_REG_ADDR = 0x00
    MIC_IF_CTRL_2_REG_ADDR = 0x01
    MIC_IF_CTRL_2_REG_ADDR = 1
    MIC_IF_CTRL_3_REG_ADDR = 0x02
    MIC_IF_CTRL_4_REG_ADDR = 0x03
    MIC_IF_STATUS_REG_ADDR = 0x06
    MIC_IF_SUM_DATA_REG_ADDR = 0x0A
    MIC_IF_DATA_REG_ADDR = 0x10
    MIC_IF_DELAY_REG_ADDR = 0x50
    
    MIC_IF_OFF_MICEN = 31
    MIC_IF_MASK_MICEN = 0x80000000
    MIC_IF_OFF_SAT = 30
    MIC_IF_MASK_SAT = 0x40000000
    MIC_IF_OFF_ROUND = 29
    MIC_IF_MASK_ROUND = 0x20000000
    MIC_IF_OFF_LRSEL = 28
    MIC_IF_MASK_LRSEL = 0x10000000
    
    MIC_IF_OFF_CICOSR = 16
    MIC_IF_MASK_CICOSR = 0x00ff0000
    MIC_IF_OFF_SHIFTROUT = 8
    MIC_IF_MASK_SHIFTROUT = 0x0000ff00
    MIC_IF_OFF_CLKDIV = 0
    MIC_IF_MASK_CLKDIV = 0x000000ff

    MIC_IF_OFF_AUD_ST_SEL = 16
    MIC_IF_MASK_AUD_ST_SEL = 0x00ff0000
    
    MIC_IF_OFF_CHEN = 0
    
    MIC_IF_OFF_AUD_ST_DIS = 31
    MIC_IF_OFF_FIL_ST_DIS = 30
    MIC_IF_OFF_BF_ST_EN = 29
    MIC_IF_OFF_FFTPTS = 0
    
    MIC_IF_OFF_DREADY = 0
    MIC_IF_MASK_DREADY = 0x1
    
    MIC_IF_OFF_DELAY = 0
    MIC_IF_MASK_DELAY = 0x0000ffff
    
    MIC_REG = np.zeros(300, dtype=int)
    
    def __init__ (self, jtag_client, num_chs, MIC_IF_BASE=0, mic_failing=[]):
        self.MIC_IF_BASE = MIC_IF_BASE
        self.jtag_client = jtag_client
        self.num_chs = num_chs
        self.mic_failing = mic_failing
    
    def write_reg (self, address, data): 
        self.jtag_client.WriteMaster(self.MIC_IF_BASE+4*address, data)
        self.MIC_REG[address] = data

    def read_reg (self, address): 
        return self.jtag_client.ReadMaster(self.MIC_IF_BASE+4*address)

    def set_bit (self, address, offset, fast=False): 
        if fast:
            self.write_reg(address, self.MIC_REG[address] | (0x01<<offset) )
        else:
            self.write_reg(address, self.read_reg(address) | (0x01<<offset) )

    def clr_bit (self, address, offset, fast=False): 
        if fast:
            self.write_reg(address, self.MIC_REG[address] & ~(0x01<<offset) )
        else:
            self.write_reg(address, self.read_reg(address) & ~(0x01<<offset))

    def set_mask (self, address, value, offset, mask, fast=False):
        if fast:
            self.write_reg(address, (self.MIC_REG[address] & ~mask) | (value<<offset))
        else:
            self.write_reg(address, (self.read_reg(address) & ~mask) | (value<<offset))
    
    def enable(self, value, verbose=True, fast=False):
        if (value):
            self.set_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_MICEN, fast)
            if verbose:
                print "[MIC IF]: Module enabled"
        else:
            self.clr_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_MICEN, fast)
            if verbose:
                print "[MIC IF]: Module disabled"

    def clk_div(self, value):
        self.set_mask(self.MIC_IF_CTRL_1_REG_ADDR, value, self.MIC_IF_OFF_CLKDIV, \
             self.MIC_IF_MASK_CLKDIV) 
        print "[MIC IF]: CLKDIV=%x"%(value)
    
    def shift_right(self, value):
        self.set_mask(self.MIC_IF_CTRL_1_REG_ADDR, value, self.MIC_IF_OFF_SHIFTROUT, \
             self.MIC_IF_MASK_SHIFTROUT) 
        print "[MIC IF]: SHIFTROUT=%x"%(value)

    def cic_osr(self, value):
        self.set_mask(self.MIC_IF_CTRL_1_REG_ADDR, value, self.MIC_IF_OFF_CICOSR, \
             self.MIC_IF_MASK_CICOSR) 
        print "[MIC IF]: CICOSR=%x"%(value)

    def saturation(self, value):
        if (value):
            self.set_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_SAT)
            print "[MIC IF]: Saturation enabled"
        else:
            self.clr_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_SAT)
            print "[MIC IF]: Saturation disabled"
    
    def round_off(self, value):
        if (value):
            self.set_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_ROUND)
            print "[MIC IF]: Round-off enabled"
        else:
            self.clr_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_ROUND)
            print "[MIC IF]: Round-off disabled"

    def channel_en(self, ch_num, value):
        if (value):
            if ch_num < 32:
                self.set_bit(self.MIC_IF_CTRL_2_REG_ADDR, ch_num+self.MIC_IF_OFF_CHEN)
            else:
                self.set_bit(self.MIC_IF_CTRL_3_REG_ADDR, ch_num-32+self.MIC_IF_OFF_CHEN)
            print "[MIC IF]: Channel %d enabled" %ch_num
        else:
            if ch_num < 32:
                self.clr_bit(self.MIC_IF_CTRL_2_REG_ADDR, ch_num+self.MIC_IF_OFF_CHEN)
            else:
                self.clr_bit(self.MIC_IF_CTRL_3_REG_ADDR, ch_num-32+self.MIC_IF_OFF_CHEN)
            print "[MIC IF]: Channel %d disabled" %ch_num
    
    def is_ready (self):
        if self.read_reg(self.MIC_IF_STATUS_REG_ADDR) & self.MIC_IF_MASK_DREADY :
            print "[MIC IF]: Data is ready"
            return True 
        else:
            return False

    def clr_ready (self):
        self.set_bit(self.MIC_IF_STATUS_REG_ADDR, MIC_IF_OFF_DREADY)
        print "[MIC IF]: Data flag cleared."

    def get_data(self, ch_num):
        return self.read_reg(self.MIC_IF_DATA_REG_ADDR+ch_num)

    def get_sum_data(self, ch_num):
        return self.read_reg(self.MIC_IF_SUM_DATA_REG_ADDR)

    def get_delay(self, del_num):
        return self.read_reg(self.MIC_IF_DELAY_REG_ADDR+del_num)

    def set_delay(self, del_num, value, verbose=True):
        self.write_reg(self.MIC_IF_DELAY_REG_ADDR+del_num, value)
        if verbose:
            print "[MIC IF]: delay[%d] = %d" %(del_num, value)
        return

    def set_right(self, value): 
        if (value):
            self.set_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_LRSEL)
            print "[MIC IF]: Clock control set to right"
        else:
            self.clr_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_LRSEL)
            print "[MIC IF]: Clock control set to left"

    def avalon_st_bytestream(self, enable, channel=0, fast=False, verbose=True): 
        if enable:
            self.clr_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_AUD_ST_DIS, fast)
            if verbose:
                print "[MIC IF]: Avalon-ST Bytestream enabled."
        else:
            self.set_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_AUD_ST_DIS, fast)
            if verbose:
                print "[MIC IF]: Avalon-ST Bytestream disabled."
        
        self.set_mask(self.MIC_IF_CTRL_4_REG_ADDR, channel, self.MIC_IF_OFF_AUD_ST_SEL, self.MIC_IF_MASK_AUD_ST_SEL, fast) 
        if verbose:
            print "[MIC IF]: Avalon-ST Bytestream channel select:%d" %(channel)

    def avalon_st_filter(self, value): 
        if (value):
            self.clr_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_FIL_ST_DIS)
            print "[MIC IF]: Avalon-ST Filter enabled."
        else:
            self.set_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_FIL_ST_DIS)
            print "[MIC IF]: Avalon-ST Filter disabled."

    def avalon_st_beam(self, value): 
        if (value):
            self.set_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_BF_ST_EN)
            print "[MIC IF]: Avalon-ST Beamforming enabled."
        else:
            self.clr_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_BF_ST_EN)
            print "[MIC IF]: Avalon-ST Beamforming disabled."

    def show_config(self):
        print "[MIC IF]: CTRL_1: %#010x" %self.read_reg(self.MIC_IF_CTRL_1_REG_ADDR)
        print "[MIC IF]: CTRL_2: %#010x" %self.read_reg(self.MIC_IF_CTRL_2_REG_ADDR)
        print "[MIC IF]: CTRL_3: %#010x" %self.read_reg(self.MIC_IF_CTRL_3_REG_ADDR)
        print "[MIC IF]: CTRL_4: %#010x" %self.read_reg(self.MIC_IF_CTRL_4_REG_ADDR)
        print "[MIC IF]: STATUS: %#010x" %self.read_reg(self.MIC_IF_STATUS_REG_ADDR)
    
    def show_data(self):
        for i in range(self.num_chs):
            print "[MIC IF]: DATA_%d:  %#010x" %(i, self.get_data(i))

    def show_delay(self):
        for i in range(self.num_chs):
            print "[MIC IF]: DELAY_%d:  %#010x" %(i, self.get_delay(i))

    def init(self, clk="2.5M"):
        for i in range(self.num_chs):
            if i not in self.mic_failing: 
              self.channel_en(i , True)
            else:
              self.channel_en(i , False)
        self.saturation(True)        
        self.round_off(True)
        if clk == "1.25M":
            self.cic_osr(25)  # pdm_clk/f_out -1 (pdm_clk=1.25MHz, fout=48KHz)
            self.shift_right(4)
            self.clk_div(20) # pdm_clk = osc_clk/(2*(clk_div))(osc_clk = 50MHz, pdm_clk=1.25MHz) 
        elif clk == "2.5M":
            self.cic_osr(51)  # pdm_clk/f_out -1 (pdm_clk=2.5MHz, fout=48KHz)
            self.shift_right(17)
            self.clk_div(10) # pdm_clk = osc_clk/(2*(clk_div))(osc_clk = 50MHz, pdm_clk=2.5MHz) 
        self.avalon_st_bytestream(True)
        self.avalon_st_filter(False)
        self.avalon_st_beam(False)
        self.enable(True)
        
        self.show_config()
        self.show_data()

    def init_array (self, pos_xy):
        self.num_ch_xy = len(pos_xy)
        center = np.sum(np.array(pos_xy), axis=0)/(len(pos_xy)-len(self.mic_failing))
        print "array center:", center

        self.pos = np.zeros((len(pos_xy), 3, 1))
        
        for i in np.arange(len(pos_xy)):
          self.pos[i] = (np.array(pos_xy[i])-center).reshape((3,1))

    def init_array_bbb (self):
        
        array_pos = [[0.065,0.060,0.], [0.065,0.080,0.], [0.065,0.110,0.], [0.065,0.150,0.], [0.065,0.190,0.], \
                     [0.076,0.060,0.], [0.076,0.080,0.], [0.076,0.110,0.], [0.076,0.150,0.], [0.076,0.190,0.], \
                     [0.098,0.060,0.], [0.098,0.080,0.], [0.098,0.110,0.], [0.098,0.150,0.], [0.098,0.190,0.], \
                     [0.131,0.060,0.], [0.131,0.080,0.], [0.131,0.110,0.], [0.131,0.150,0.], [0.131,0.190,0.], \
                     [0.153,0.060,0.], [0.153,0.080,0.], [0.153,0.110,0.], [0.153,0.150,0.], [0.153,0.190,0.], \
                     [0.197,0.060,0.], [0.197,0.080,0.], [0.197,0.110,0.], [0.197,0.150,0.], [0.197,0.190,0.], \
                     [0.241,0.060,0.], [0.241,0.080,0.], [0.241,0.110,0.], [0.241,0.150,0.], [0.241,0.190,0.], \
                     [0.263,0.060,0.], [0.263,0.080,0.], [0.263,0.110,0.], [0.263,0.150,0.], [0.263,0.190,0.] ]

        self.init_array(array_pos)

    def init_array_bbb_30 (self):
        
        array_pos = [[0.065,0.060,0.], [0.065,0.080,0.], [0.065,0.110,0.], [0.065,0.150,0.], [0.065,0.190,0.], \
                     [0.076,0.060,0.], [0.076,0.080,0.], [0.076,0.110,0.], [0.076,0.150,0.], [0.076,0.190,0.], \
                     [0.098,0.060,0.], [0.098,0.080,0.], [0.098,0.110,0.], [0.098,0.150,0.], [0.098,0.190,0.], \
                     [0.131,0.060,0.], [0.131,0.080,0.], [0.131,0.110,0.], [0.131,0.150,0.], [0.131,0.190,0.], \
                     [0.153,0.060,0.], [0.153,0.080,0.], [0.153,0.110,0.], [0.153,0.150,0.], [0.153,0.190,0.], \
                     [0.197,0.060,0.], [0.197,0.080,0.], [0.197,0.110,0.], [0.197,0.150,0.], [0.197,0.190,0.], \
                     [0.241,0.060,0.], [0.241,0.080,0.], [0.241,0.110,0.], [0.241,0.150,0.], [0.241,0.190,0.], \
                     [0.263,0.060,0.], [0.263,0.080,0.], [0.263,0.110,0.], [0.263,0.150,0.], [0.263,0.190,0.] ]

        for i in range(self.num_chs):
            if i in self.mic_failing: 
                array_pos[i] = [0.0, 0.0, 0.0]
        
        self.init_array(array_pos)

    def set_bf_angle(self, angle_polar, angle_azim = 0., verbose=False, max_delay=60):
        # TODO: expand to two-dimensional

        # Mic position 
        r = self.pos

        tdel = np.zeros((self.num_ch_xy, 1))
        ndel = np.zeros(self.num_ch_xy, dtype=int)
        ndel_norm = np.zeros(self.num_ch_xy, dtype=int)

        # Light speed
        c = 340.
        fso = 48e3
        
        # Angle in rad
        angle_polar_deg = angle_polar*180./np.pi
        angle_azim_deg = angle_azim*180./np.pi
        
        # source wave vector
        #rbf_u = 1./c*np.array([[np.cos(angle_polar),0., -np.sin(angle_polar)]]).transpose()
        rbf_u = 1./c*np.array([[np.cos(angle_polar)*np.cos(angle_azim),np.cos(angle_polar)*np.sin(angle_azim), -np.sin(angle_polar)]]).transpose()

        # delay
        for i in np.arange(len(r)):
            #tdel[i] = -np.matmul(r[i].transpose(),rbf_u)
            tdel[i] = np.matmul(r[i].transpose(),rbf_u)
            ndel[i] = np.round(tdel[i]*fso)
        
        ndel_norm = ndel + max_delay/2
        #ndel_norm = ndel 

        if verbose:
            print "angle %d:"%(angle_polar_deg), ndel_norm
        
        for i in np.arange(len(r)):
            self.set_delay(i, ndel_norm[i], verbose=False)
        
        
