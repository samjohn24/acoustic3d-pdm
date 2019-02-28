import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation
import time
import jtag_client as jtag
import mic_if_hal as mic_if
 
MIC_IF_BASE = 0x4080000

SHOW_FRAME = 48*100
NUM_SAMPLES = 48*10
#NUM_SAMPLES = 48
 
# Open JTAG Master client
jtag_master = jtag.AlteraJTAGClient()

# Microphone interface
mic = mic_if.mic_if_hal(jtag_master,num_chs=4, MIC_IF_BASE=MIC_IF_BASE)

# Microphone initialization
mic.init()

# Start Bytestream Server
jtag_master.StartBytestreamServer()

# Open Bytetream client
jtag_bytestream = jtag.BytestreamClient(max_misses=10000)

# Data container
y_data = []

fig = plt.figure()
ax1 = fig.add_subplot(1,1,1)

period = time.time()
    
def get_data(i):

    global y_data
    global start
    global period

    start = time.time()

    data_int = jtag_bytestream.GetShortSamples(NUM_SAMPLES, verbose=False)

    proc_time = time.time() - start

    y_data = y_data[-(SHOW_FRAME-NUM_SAMPLES):] + data_int
      
    ax1.clear()
    ax1.plot(y_data)
    ax1.grid()
    ax1.set_ylim(-2**15, 2**15)

    print 'period: %.2f ms,\t proc: %.2f ms' %((time.time()-period)*1e3, proc_time*1e3) 
    period = time.time()

an1 = animation.FuncAnimation(fig, get_data, interval=1)
plt.show()

#for i in range(10):
#    #WriteMaster(conn, 0x0424+i, 0x3423412)
#    jtag_master.WriteMaster(MIC_IF_BASE, i)
#    print jtag_master.ReadMaster(MIC_IF_BASE)


#data_int = jtag_bytestream.GetShortSamples(NUM_SAMPLES, verbose=True)
#
#jtag_master.close()

