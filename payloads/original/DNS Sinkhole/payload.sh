#!/bin/bash

# Title:        DNS Sinkhole
#
# Description: Demonstrate sinkholing a DNS domain (hak5.org) 

# This payload will intercept any requests for a *.hak5.org domain 
# and redirect them to localhost (127.0.0.1 for IPv4 or ::1 for IPv6)

NETMODE BRIDGE 

LED R SINGLE

SPOOFDNS br-lan '.*.hak5.org=127.0.0.1' 'hak5.org=127.0.0.1' '.*.hak5.org=::1' 'hak5.org=::1' 
