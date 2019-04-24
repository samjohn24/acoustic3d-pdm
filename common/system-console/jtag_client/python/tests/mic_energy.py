#! /usr/bin/env python
"""
 +FHDR-------------------------------------------------------------------------
 FILE NAME      : mic_energy.py
 AUTHOR         : Sammy Carbajal
 ------------------------------------------------------------------------------
 PURPOSE
  Script for show output energy at real-time in Beaglebone Black board.
 -FHDR-------------------------------------------------------------------------
"""

import sys
sys.path.append('../jtag_client')

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation
import time
import Queue
import jtag_client as jtag
import mic_if_hal as mic_if

# =======================
#   General parameters
# =======================
 
MIC_IF_BASE = 0x4080000

ANGLE = 90.
CHANNEL = 0xff

JTAG_PACKET_LEN = 48*10 #10ms
BUF_PACKET_LEN = 10  # 100ms
FRAME_LEN = 10     #1s
BUF_MAX_LEN = 10
SHOW_FRAME = FRAME_LEN
NUM_CHS = 40

# Max energy 
max_val = 2**15
max_energy_val = max_val*0.5
 
# =======================
#      Configuration
# =======================

# Open JTAG Master client
jtag_master = jtag.AlteraJTAGClient()

# Mics failing
mic_failing = [6]

# Microphone interface
mic = mic_if.mic_if_hal(jtag_master,num_chs=NUM_CHS, MIC_IF_BASE=MIC_IF_BASE, mic_failing=mic_failing)

# Microphone initialization
mic.init(clk="1.25M")

# Select beamformer channel
mic.avalon_st_bytestream(True, CHANNEL)
mic.show_config()

# Init array
mic.init_array_bbb_30()
mic.set_bf_angle(np.pi/180.*ANGLE, verbose=True)

mic.show_delay()

# Start Bytestream Server
jtag_master.StartBytestreamServer()

# Queue
queue = Queue.Queue()

# Create Bytetream client
jtag_bytestream = jtag.BytestreamClient(queue, jtag_packet_len=JTAG_PACKET_LEN, buf_packet_len=BUF_PACKET_LEN, buf_maxlen=BUF_MAX_LEN)

# Define client as daemon
jtag_bytestream.setDaemon(True)

# Start Bytestream client
jtag_bytestream.start()

# =======================
#      Plot data
# =======================

# Data container
y_data = np.zeros(SHOW_FRAME)
    
fig = plt.figure()
ax1 = fig.add_subplot(1,1,1)

period = time.time()

def plot_data(i):

    global y_data
    global start
    global period

    data_int = np.array(jtag_bytestream.getDataN(3))

    data_energy = np.std(data_int)

    y_data = np.concatenate((y_data[-(SHOW_FRAME-1):],np.array([data_energy])))
      
    ax1.clear()
    ax1.stem(y_data)
    ax1.grid()
    ax1.set_ylim(0, max_energy_val)

    period = time.time()

# =======================
#     Run animation
# =======================
an1 = animation.FuncAnimation(fig, plot_data, interval=250)
plt.show()

