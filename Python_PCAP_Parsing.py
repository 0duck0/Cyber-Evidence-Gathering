#!/usr/bin/env python

import dpkt
import sys
import socket

f = open('test2.pcap', "rb")
pcap = dpkt.pcap.Reader(f)


for ts, buf in pcap:
  try:
  if dpkt.ethernet.Ethernet(buf)!=2048: #For ipv4, dpkt.ethernet.Ethernet(buf).type =2048        
   eth = dpkt.ethernet.Ethernet(buf)
   ip = eth.data
   tcp = ip.data
   print "Source IP "
   print socket.inet_ntoa(ip.src)
   print "Destination IP "
   print socket.inet_ntoa(ip.dst)
 
  if tcp.dport == 80 and len(tcp.data) > 0:
   http = dpkt.http.Request(tcp.data)
   print "got to http"
   print http
 
  elif tcp.sport == 80 and len(tcp.data) > 0: 
   http = dpkt.http.Request(tcp.data)
   print http
   
  else:
   print "non http traffic"
   #print pcap
  except:
    print "error "+str(IOError)
    pass     
 #print pcap
  
f.close()

