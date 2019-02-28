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
    
    MIC_IF_OFF_CHEN = 0
    
    MIC_IF_OFF_AUD_ST_DIS = 31
    MIC_IF_OFF_FIL_ST_DIS = 30
    MIC_IF_OFF_BF_ST_EN = 29
    MIC_IF_OFF_FFTPTS = 0
    
    MIC_IF_OFF_DREADY = 0
    MIC_IF_MASK_DREADY = 0x1
    
    MIC_IF_OFF_DELAY = 0
    MIC_IF_MASK_DELAY = 0x0000ffff
    
    def __init__ (self, jtag_client, num_chs, MIC_IF_BASE=0):
        self.MIC_IF_BASE = MIC_IF_BASE
        self.jtag_client = jtag_client
        self.num_chs = num_chs
    
    def write_reg (self, address, data): 
        self.jtag_client.WriteMaster(self.MIC_IF_BASE+4*address, data)

    def read_reg (self, address): 
        return self.jtag_client.ReadMaster(self.MIC_IF_BASE+4*address)

    def set_bit (self, address, offset): 
        self.write_reg(address, self.read_reg(address) | (0x01<<offset) )

    def clr_bit (self, address, offset): 
        self.write_reg(address, self.read_reg(address) & ~(0x01<<offset))

    def set_mask (self, address, value, offset, mask):
        self.write_reg(address, (self.read_reg(address) & ~mask) | (value<<offset))
    
    def enable(self, value):
        if (value):
            self.set_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_MICEN)
            print "[MIC IF]: Module enabled"
        else:
            self.clr_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_MICEN)
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

    def set_delay(self, del_num, value):
        return self.write_reg(self.MIC_IF_DELAY_REG_ADDR+del_num, value)

    def set_right(self, value): 
        if (value):
            self.set_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_LRSEL)
            print "[MIC IF]: Clock control set to right"
        else:
            self.clr_bit(self.MIC_IF_CTRL_1_REG_ADDR, self.MIC_IF_OFF_LRSEL)
            print "[MIC IF]: Clock control set to left"

    def avalon_st_bytestream(self, value): 
        if (value):
            self.clr_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_AUD_ST_DIS)
            print "[MIC IF]: Avalon-ST Bytestream enabled."
        else:
            self.set_bit(self.MIC_IF_CTRL_4_REG_ADDR, self.MIC_IF_OFF_AUD_ST_DIS)
            print "[MIC IF]: Avalon-ST Bytestream disabled."

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

    def init(self):
        for i in range(self.num_chs):
            self.channel_en(i , True)
        self.saturation(True)        
        self.round_off(True)
        self.cic_osr(51)
        self.shift_right(16)
        self.clk_div(10)
        self.avalon_st_bytestream(True)
        self.avalon_st_filter(False)
        self.avalon_st_beam(False)
        self.enable(True)
        
        self.show_config()
        self.show_data()
