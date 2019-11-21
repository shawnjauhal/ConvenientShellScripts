#! /bin/bash

##################-PSAD Quick Install-######################
#                                                          #
# (RUN AS ROOT)                                            #
# This script is for a quick install and configuration for #
# the PSAD package for Ubuntu 16.03 and beyond.  It will   #
# prompt the user for their IP Address and set up the      #
# basic configuration accordingly.                         #
#                                                          #
# Author: Shawn Jauhal                                     #
# Date:   November 21st, 2019                              #
############################################################

ip address
read -p "Please enter your IP Address/Range: " ipaddress

apt-get update
apt-get install psad

iptables -A INPUT -j LOG
iptables -A FORWARD -j LOG
iptables -L

rm /etc/psad/psad.conf
sed -i "28iHOSTNAME $HOSTNAME;" new_psad.conf
sed -i "35iHOME_NET $ipaddress;;" new_psad.conf
cp new_psad.conf /etc/psad/psad.conf
psad --sig-update
