import socket
import textwrap
import struct
import time
import collections
import threading
import Queue
 
class AlteraJTAGClient:

    def __init__(self, host='localhost', port=2540):
        self.host = host
        self.port = port
        self.conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.conn.connect(( host,port))

    def close(self):
        self.conn.close()

    def WriteMaster(self, address, data):
        self.conn.send("00 %d %d\n" %(address, data))

    def ReadMaster(self, address):
        self.conn.send("01 %d\n" %(address))
        data = self.conn.recv(10)
        self.conn.recv(2)
        return int(data[2:10],16)

    def StartBytestreamServer(self, port=2541, address=0):
        self.conn.send("04 %d %d\n" %(port, address))
        while self.conn.recv(1) != "1":
            pass
        self.conn.recv(2)

class BytestreamClient(threading.Thread):

    def __init__(self, queue, host='localhost', port=2541, max_misses=10, jtag_buf_size=48*10, buf_elem_size=48*100, buf_maxlen=2):
        threading.Thread.__init__(self)
        self.queue = queue
        self.host = host
        self.port = port
        self.num_misses = 0
        self.max_misses = max_misses
        self.buf_elem_size = buf_elem_size
        self.jtag_buf_size = jtag_buf_size
        
        # Socket create and connect
        self.conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.conn.connect(( host,port))
        
        # Buffer deque create
        self.buffer = collections.deque(maxlen=buf_maxlen)

    def str2short(self, hexstr):
        """
        Convert a little endian bytestring(hex format) to short
        Ex: "2345" -> 13330 
        """
        return struct.unpack('<h',bytearray([int(hexstr[0:2],16),int(hexstr[2:4],16)]))[0]

    def ascii2short(self, char):
        """
        Convert a little endian bytestring(hex format) to short
        Ex: "xc" -> 13330 
        """
        return struct.unpack('<h',char)[0]
        
    def GetBytestream(self, size):
        return self.conn.recv(size)
    
    def ReqShortSamples(self, num_samples=48*10):
        self.conn.send(str(num_samples) + '\n')

    def RecvPacketAscii(self, verbose=False):

        # Receive packet length
        try:
            packet_len = int(self.conn.recv(6))+2
            if verbose:
                print 'packet len: %d'%packet_len
        except ValueError:
            return ""

        # Receive packet
        data = ""
        while (len(data) < packet_len):
            start = time.time()
            if verbose:
                print '\ttry to receive %d bytes' % (packet_len-len(data))

            packet = self.conn.recv(packet_len - len(data))
            if verbose:
                print '\treceived %d bytes: "%s"' % (len(packet),list(packet))
                print '\tproc recv packet: %.2f ms' %((time.time()-start)*1e3) 

            data += packet
            data = data[:-1].replace('\r\n','\n')+data[-1]
            if verbose:
                print '\tproc total packet: %.2f ms' %((time.time()-start)*1e3) 
        
        if verbose:
            print 'total received %d bytes: "%s"' % (len(data),list(data))

        # Check is even and return
        if len(data) % 2 == 0:
            return data[:-2]
        else:
            return data[:-3]
        
    def RecvPacketRaw(self, verbose=False):

        # Receive packet length
        try:
            packet_len = int(self.conn.recv(6))+2
            if verbose and packet_len>2:
                print 'packet len: %d'%packet_len
        except ValueError:
            return ""

        # Receive packet
        data = ""
        while (len(data) < packet_len):
            start = time.time()

            if verbose and packet_len>2:
                print '\ttry to receive %d bytes' % (packet_len-len(data))
            packet = self.conn.recv(packet_len - len(data))

            if verbose and packet_len>2:
                print '\treceived %d bytes: "%s"' % (len(packet),list(packet))
                print '\tproc recv packet: %.2f ms' %((time.time()-start)*1e3) 

            data += packet
            data = data[:-1].replace('\r\n','\n')+data[-1]
            if verbose and packet_len>2:
                print '\tproc total packet: %.2f ms' %((time.time()-start)*1e3) 
        
        if verbose and packet_len>2:
            print 'total received %d bytes: "%s"' % (len(data),list(data))

        return data[:4*((len(data)-2)/4)]

    def RawToInt (self, data, verbose=False):
        start = time.time()

        data_out = ""
        for i in range(0,len(data),4):
            data_out += chr(int(data[i:i+2],16))+chr(int(data[i+2:i+4],16))

        if verbose:
            print 'total received parsed %d bytes: "%s"' % (len(data_out),list(data_out))
            print '\tproc RawParse: %.2f ms' %((time.time()-start)*1e3) 

        # Parse TODO: Verify if this conversion is correct
        data_int = struct.unpack('<'+'h'*(len(data_out)/2),data_out)

        if verbose:
            print 'total received %d samples: "%s"' % (len(data_int),list(data_int))
            print '\tproc RawToInt: %.2f ms' %((time.time()-start)*1e3) 

        return data_int

    def GetSamples(self, num_samples=48*10, verbose=False):
        # Request samples
        self.conn.send(str(num_samples) + '\n')

        # Receive raw packet
        data_raw = self.RecvPacketRaw(verbose)

        # Convert to Int
        data_int = self.RawToInt(data_raw, verbose)

        return list(data_int)

    def getData (self, verbose=False):
        return self.RawToInt(self.buffer.pop()[0], verbose)

    def run(self):
        verbose = False
        data_raw = ""

        while (True):

            while(len(data_raw) < 4*self.buf_elem_size):

                # Request samples
                self.conn.send(str(self.jtag_buf_size) + '\n')

                # Receive raw packet
                data_raw += self.RecvPacketRaw(verbose)
                
                #time.sleep(0.001)
            
            # Save into buffer
            self.buffer.appendleft([data_raw[:4*self.buf_elem_size]])

            if verbose:
                print 'buffer len %d:' %(len(self.buffer)),self.buffer

            # Clear buffered samples
            data_raw = data_raw[4*self.buf_elem_size:]
            
            # Send message
            if len(self.buffer) > 1:
                self.queue.put("quit")
            else:
                self.queue.put("new data elem")
