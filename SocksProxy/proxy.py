#!/usr/bin/env python3
# encoding: utf-8
# SOCKs Proxy by X-DCB
import socket, threading, _thread, select, signal, sys, time
from os import system
system("clear")
IP = "0.0.0.0"
try:
   PORT = int(sys.argv[1])
except:
   PORT = 80
try:
	TIMER = int(sys.argv[2])
except:
	TIMER = 50
PASS = ""
BUFLEN = 8196 * 8
TIMEOUT = 60
DEFAULT_HOST = "0.0.0.0:22"
RESPONSE = b"HTTP/1.1 200 <font color=\"green\">Dexter Cellona Banawon (X-DCB)</font>\r\n\r\n"

class Server(threading.Thread):
    def __init__(self, host, port):
        threading.Thread.__init__(self)
        self.running = False
        self.host = host
        self.port = port
        self.threads = []
        self.threadsLock = threading.Lock()

    def run(self):
        self.soc = socket.socket(socket.AF_INET)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.settimeout(2)
        self.soc.bind((self.host, self.port))
        self.soc.listen(0)
        self.running = True

        try:
            while self.running:
                try:
                    c, addr = self.soc.accept()
                    c.setblocking(1)
                except socket.timeout:
                    continue

                conn = ConnectionHandler(c, self, addr)
                conn.start();
                self.addConn(conn)
        finally:
            self.running = False
            self.soc.close()

    def addConn(self, conn):
        try:
            self.threadsLock.acquire()
            if self.running:
                self.threads.append(conn)
        finally:
            self.threadsLock.release()

    def removeConn(self, conn):
        try:
            self.threadsLock.acquire()
            if conn in self.threads:
                self.threads.remove(conn)
        finally:
            self.threadsLock.release()

    def close(self):
        try:
            self.running = False
            self.threadsLock.acquire()

            threads = list(self.threads)
            for c in threads:
                c.close()
        finally:
            self.threadsLock.release()


class ConnectionHandler(threading.Thread):
    def __init__(self, socClient, server, addr):
        threading.Thread.__init__(self)
        self.clientClosed = False
        self.targetClosed = True
        self.client = socClient
        self.client_buffer = ""
        self.server = server
        self.cl_addr = addr

    def close(self):
        try:
            if not self.clientClosed:
                self.client.shutdown(socket.SHUT_RDWR)
                self.client.close()
        except:
            pass
        finally:
            self.clientClosed = True

        try:
            if not self.targetClosed:
                self.target.shutdown(socket.SHUT_RDWR)
                self.target.close()
        except:
            pass
        finally:
            self.targetClosed = True
    
    def logfile(self, msg):
    	f = open("log.txt", "a")
    	f.write(msg+"\n")
    	f.close()
    
    def log_time(self, msg):
    	#print(time.strftime("[%H:%M:%S]"), msg)
    	pass

    def run(self):
        try:
            self.client_buffer = self.client.recv(BUFLEN)
            
            strbuff = str(self.client_buffer)

            hostPort = self.findHeader(self.client_buffer, "X-Real-Host")
            
            if "CONNECT" in strbuff:
            	f=strbuff.find('CONNECT')
            	cc=strbuff[f:strbuff.find('\r\n',f)]
            	x=cc.find(' ')
            	hostPort=cc[x:cc.find(' ',x+1)].strip()
            	print("found:", hostPort)

            if hostPort == "":
                hostPort = DEFAULT_HOST

            self.log_time("client: %s - server: %s - buff: %s" % (self.cl_addr, hostPort, self.client_buffer))

            split = self.findHeader(self.client_buffer, "X-Split")

            if split != "":
                self.client.recv(BUFLEN)

            if hostPort != "":
                passwd = self.findHeader(self.client_buffer, "X-Pass")
                
                if len(PASS) != 0 and passwd == PASS:
                    self.method_CONNECT(hostPort)
                elif len(PASS) != 0 and passwd != PASS:
                    self.client.send(b"HTTP/1.1 400 WrongPass!\r\n\r\n")
                
                self.method_CONNECT(hostPort)
            else:
                self.log_time("- No X-Real-Host!")
                self.client.send(b"HTTP/1.1 400 NoXRealHost!\r\n\r\n")
        except Exception as e:
            #print("Error: ", str(e))
            pass
        finally:
            self.close()
            self.server.removeConn(self)

    def findHeader(self, head, header):
        aux = str(head).find(header + ": ")

        if aux == -1:
            return ""

        aux = head.find(":", aux)
        head = head[aux+2:]
        aux = head.find("\r\n")

        if aux == -1:
            return ""

        return head[:aux]

    def connect_target(self, host):
        i = host.find(':')
        if i != -1:
            port = int(host[i+1:])
            host = host[:i]
        else:
            if self.method=="CONNECT":
                port = 443
            else:
                port = 22

        (soc_family, soc_type, proto, _, address) = socket.getaddrinfo(host, port)[0]

        self.target = socket.socket(soc_family, soc_type, proto)
        self.targetClosed = False
        self.target.connect(address)
        self.t_addr = address

    def method_CONNECT(self, path):
        self.connect_target(path)
        self.client.sendall(RESPONSE)
        self.client_buffer = ""
        self.time_start = time.time()
        self.doCONNECT()

    def doCONNECT(self):
        socs = [self.client, self.target]
        error = False
        while True:
            (recv, _, err) = select.select(socs, [], socs, 3)
            if int(time.time() - self.time_start) > TIMER:
            	self.close()
            	self.server.removeConn(self)
            	self.log_time("Client disconnected (timer)")
            	break
            if err:
                continue
            if recv:
                for in_ in recv:
                    try:
                        data = in_.recv(BUFLEN)
                        if data:
                            if in_ is self.target:
                                try:
                                    self.client.connect(self.cl_addr)
                                except:
                                    pass
                                self.client.send(data)
                            else:
                                try:
                                    self.target.connect(self.t_addr)
                                except Exception as e:
                                    pass
                                while data:
                                    byte = self.target.send(data)
                                    data = data[byte:]
                    except:
                        pass
            



def main():
    print("\033[0;34m="*8,"\033[1;32mPROXY SOCKS","\033[0;34m="*8,"\n")
    print("\033[1;33mIP:\033[1;32m",IP)
    print("\033[1;33mPORT:\033[1;32m", PORT)
    print("\033[1;33mTIMER:\033[1;32m ", TIMER, "sec\n")
    print("\033[0;34m="*11,"\033[1;32mX-DCB","\033[0;34m=\033[1;37m"*11,"\n")
    server = Server(IP, PORT)
    server.start()
    while True:
        try:
            time.sleep(2)
        except KeyboardInterrupt:
            server.close()
            print("\nCancelled...")
            break

if __name__ == "__main__":
    main()