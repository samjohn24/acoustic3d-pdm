import socket
import textwrap
import struct
 
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

class BytestreamClient:

    def __init__(self, host='localhost', port=2541, max_misses=10):
        self.host = host
        self.port = port
        self.num_misses = 0
        self.max_misses = max_misses
        self.conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.conn.connect(( host,port))

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

    def RecvPacket(self, verbose=False):

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
            packet = self.conn.recv(packet_len - len(data))
            if verbose:
                print 'received %d bytes: "%s"' % (len(packet),list(packet))
            data += packet
            data = data[:-1].replace('\r\n','\n')+data[-1]
        
        if verbose:
            print 'total received %d bytes: "%s"' % (len(data),list(data))

        # Check is even and return
        if len(data) % 2 == 0:
            return data[:-2]
        else:
            return data[:-3]
        

    def GetShortSamples(self, num_samples=48*10, verbose=False):
        # Received samples
        data = ""

        # Request samples
        self.conn.send(str(num_samples) + '\n')

        # Receive packet
        data = self.RecvPacket(verbose)
        
        # Parse TODO: Verify if this conversion is correct
        data_int = struct.unpack('<'+'h'*(len(data)/2),data)

        return list(data_int)
