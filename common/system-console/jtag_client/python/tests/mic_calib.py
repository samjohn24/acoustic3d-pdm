#! /usr/bin/env python
"""
 +FHDR-------------------------------------------------------------------------
 FILE NAME      : mic_calib.py
 AUTHOR         : Sammy Carbajal
 ------------------------------------------------------------------------------
 PURPOSE
  Script for calibrate (test) the 40 microphones in Beaglebone Black board.
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
import tonegenerator as tonegen
import pandas as pd
 
# =======================
#   General parameters
# =======================

NUM_CHS = 40
 
frequency = 400
duration = 4
amplitude = 0.20

MIC_IF_BASE = 0x4080000

JTAG_PACKET_LEN = 48*10 #10ms
BUF_PACKET_LEN = 10  # 100ms
BUF_MAX_LEN = 1
 
# =======================
#      Configuration
# =======================

# Tone generator object
tonegen = tonegen.ToneGenerator()

# Open JTAG Master client
jtag_master = jtag.AlteraJTAGClient()

# Microphone interface
mic = mic_if.mic_if_hal(jtag_master,num_chs=NUM_CHS, MIC_IF_BASE=MIC_IF_BASE)

# Microphone initialization
mic.init(clk="1.25M")

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

# Data frame
df = pd.DataFrame()

# =======================
#  Test all microphones 
# =======================
for i in range(NUM_CHS):
    tonegen.play(frequency, duration, amplitude)
    mic.avalon_st_bytestream(True, i)
    time.sleep(2)
    df["M %02d"%(i)] = pd.Series(np.array(jtag_bytestream.getDataN(1)))
    print "MIC %02d:" %i
    time.sleep(3)

# =======================
#    Analyzing results
# =======================

# Test all microphones 
print df
print df.describe()

df.plot(subplots=True, legend=False, sharex=True, sharey=True, layout=(8,5))
#df.plot.box()

plt.figure()
df.mean().plot.bar(yerr=df.std())

#df.plot.kde(subplots=True, legend=False, sharex=True, sharey=True, layout=(8,5))
#df.kde(color='k')

#df.describe().plot.bar()

plt.figure()
df.mean().plot()

#df.plot.hist()
df.hist(color='k', bins=50, layout=(8,5))

plt.show()
