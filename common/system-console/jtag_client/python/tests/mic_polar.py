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

JTAG_PACKET_LEN = 48*10 #10ms
BUF_PACKET_LEN = 10  # 100ms
FRAME_LEN = 1     #1s
BUF_MAX_LEN = 1

NUM_SAMPLES =  48*30 #30ms

# Plot parameters
plot_polar = False  # True: polar, False: linear
num_pts_polar  = 10
num_pts_azim  = 1

# =======================
#      Configuration
# =======================

# Open JTAG Master client
jtag_master = jtag.AlteraJTAGClient()

# Mics failing
mic_failing = [6]

# Microphone interface
mic = mic_if.mic_if_hal(jtag_master,num_chs=40, MIC_IF_BASE=MIC_IF_BASE, mic_failing=mic_failing)

# Microphone initialization
mic.init(clk="1.25M")
mic.enable(False)

# Init array
mic.init_array_bbb_30()

# Select beamformer channel
mic.avalon_st_bytestream(True, 0xff)
mic.show_config()

mic.enable(True)

# Start Bytestream Server
jtag_master.StartBytestreamServer()

# Queue
queue = Queue.Queue()

# Create Bytetream client
jtag_bytestream = jtag.BytestreamClient(queue, jtag_packet_len=JTAG_PACKET_LEN, buf_packet_len=BUF_PACKET_LEN, buf_maxlen=BUF_MAX_LEN)

# =======================
#      Angle energy
# =======================

def get_angle_energy(angle_polar, angle_azim, verbose = False):
    start_time = time.time()

    mic.set_bf_angle(angle_polar, angle_azim, verbose=False)
    if verbose:
        print "\tmic.set_angle_polar proc time: %.2f ms" %((time.time()-start_time)*1e3)

    mic.avalon_st_bytestream(True, 0xff, fast=True, verbose=verbose)
    if verbose:
        print "\tmic.enable proc time: %.2f ms" %((time.time()-start_time)*1e3) 

    time.sleep(.030)

    if verbose:
        print "\tdelay time: %.2f ms" %((time.time()-start_time)*1e3) 

    data_int = np.array(jtag_bytestream.getSamples(NUM_SAMPLES))
    if verbose:
        print "\tgetSamples proc time: %.2f ms" %((time.time()-start_time)*1e3) 

    mic.avalon_st_bytestream(False, 0xff, fast=True, verbose=verbose)
    if verbose:
        print "\tmic.disable proc time: %.2f ms" %((time.time()-start_time)*1e3)

    jtag_bytestream.flushFIFO()
    if verbose:
        print "\tflushFIFO proc time: %.2f ms" %((time.time()-start_time)*1e3) 

    data_energy = np.std(data_int)
    if verbose:
        print "\tenergy proc time: %.2f ms" %((time.time()-start_time)*1e3)

    return data_energy, data_int

# =======================
#      Plot data
# =======================

max_val = 2**15
max_energy_val = max_val*0.5

fig = plt.figure()

angles_polar = np.linspace(0, np.pi, num_pts_polar)

if num_pts_azim > 1:
    angles_azim = np.linspace(-np.pi/2, np.pi/2, num_pts_azim)
else:
    angles_azim = np.array([0.])

if plot_polar:
    ax1 = fig.add_subplot(1,1,1, projection='polar')
else:
    ax1 = fig.add_subplot(1,1,1)

period = time.time()
    
def plot_data(i):

    global start
    global period

    energy_bf = np.zeros((num_pts_polar, num_pts_azim), dtype=float)

    for j in np.arange(num_pts_azim):
        for i in np.arange(num_pts_polar):
            proc_time = time.time()

            energy_bf[i,j],_ = get_angle_energy(angles_polar[i], angles_azim[j])
            energy_bf[i,j] /= max_energy_val 

            proc_time = time.time() - proc_time

    if not plot_polar:
        angles = 180./np.pi*angles_polar
    else:
        angles = angles_polar
    
    max_index = np.unravel_index(np.argmax(energy_bf, axis=None), energy_bf.shape)
    max_angle_polar = angles[max_index[0]]
    max_angle_azim  = angles_azim[max_index[1]]
    max_energy = energy_bf[max_index]

    ax1.clear()

    if len(angles) > 1:
        ax1.plot(angles, energy_bf[:,0])
    else:
        ax1.plot(angles, energy_bf[:,0], 'x')

    if not plot_polar:
        max_angle_polar_deg = max_angle_polar
    else:
        max_angle_polar_deg = max_angle_polar*180./np.pi

    ax1.plot(angles[max_index[0]], energy_bf[max_index[0]], 'x')
    ax1.set_ylim(0, 1.0)
    ax1.grid(True)

    print 'period: %.2f ms\t proc: %.2f ms \t max_angle: %.2f deg' %((time.time()-period)*1e3, proc_time*1e3, max_angle_polar_deg) 
    period = time.time()

# =======================
#     Run animation
# =======================
an1 = animation.FuncAnimation(fig, plot_data, interval=1)
plt.show()

