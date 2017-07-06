#!/usr/bin/env bash

# Sets up devstack
# DO NOT USE: This is still buggy.

sudo su -
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/suders
sudo apt-get install git -y
sudo su -stack
git clone https://git.openstack.org/openstack-dev/devstack --branch stable/newton
cd devstack
echo -e "[[local|localrc]]\nFLOATING_RANGE=192.168.1.224/27\nFIXED_RANGE=10.11.12.0/24\nFIXED_NETWORK_SIZE=256\nFLAT_INTERFACE=ens3\nADMIN_PASSWORD=stacksecret\nDATABASE_PASSWORD=stacksecret\nRABBIT_PASSWORD=stacksecret\nSERVICE_PASSWORD=stacksecret" > local.conf
./stack.sh
