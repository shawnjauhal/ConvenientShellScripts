#! /bin/bash
#  Please run as root

# read -p "Please enter how many gb of swap space you want(int): " gigabytes
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" > /etc/fstab
swapon --show
