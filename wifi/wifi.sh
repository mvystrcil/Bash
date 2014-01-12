#!/bin/bash
echo "################################################"
echo "	     Starting wifi share - pid:" $$
echo "################################################"

echo $$ > /tmp/wifi.pid

hostapd /etc/hostapd/hostapd.conf >> /dev/null & 

ifconfig wlan0 10.0.0.1 up
ifconfig wlan0 netmask 255.255.255.0
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
