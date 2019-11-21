#!/bin/bash

##################-SNORT Quick Install-#####################
#                                                          #
# (RUN AS ROOT)                                            #
# This script is for a quick install and configuration for #
# Snort with community rules for CentOS7 and beyond. It    #
# will prompt the user for their IP Address and set up the #
# basic configuration accordingly.                         #
#                                                          #
# Author: Shawn Jauhal                                     #
# Date:   November 21st, 2019                              #
############################################################

ip address
read -p "Enter your broadcast IP: " broadcast

yum update
yum install -y wget nano gcc flex bison zlib libpcap pcre libdnet tcpdump libdnet-devel
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y libnghttp2
yum install https://snort.org/downloads/snort/snort-2.9.15-1.centos7.x86_64.rpm

ldconfig
ln -s /usr/local/bin/snort /usr/sbin/snort

mkdir -p /etc/snort/rules
mkdir /var/log/snort
mkdir /usr/local/lib/snort_dynamicrules

chmod -R 5775 /etc/snort
chmod -R 5775 /var/log/snort
chmod -R 5775 /usr/local/lib/snort_dynamicrules
chown -R snort:snort /etc/snort
chown -R snort:snort /var/log/snort
chown -R snort:snort /usr/local/lib/snort_dynamicrules

touch /etc/snort/rules/white_list.rules
touch /etc/snort/rules/black_list.rules
touch /etc/snort/rules/local.rules

wget https://www.snort.org/rules/community -O ~/community.tar.gz
tar -xvf ~/community.tar.gz -C ~/
cp ~/community-rules/* /etc/snort/rules

# change later
sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/' /etc/snort/snort.conf

rm /etc/snort/snort.conf
sed -i "46iipvar HOME_NET $broadcast/32" new_conf.txt
cp new_conf.txt /etc/snort/snort.conf
rm /usr/lib64/libdnet.1
ln -s /usr/lib64/libdnet.so.1.0.1 /usr/lib64/libdnet.1
echo "Test to see if snort runs with: sudo snort -T -c /etc/snort/snort.conf"
echo "If snort does not start, reboot and try the command again, this is due to changes in symbolic links"

