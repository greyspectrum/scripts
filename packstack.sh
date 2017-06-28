#!/usr/bin/env bash

# Installs Packstack. You will need a machine with at least 8GB of volatile memory and 80GB of disk.

sudo yum install system-config-firewall
system-config-firewall
sudo yum install -y centos-release-openstack-newton
sudo yum install -y openstack-packstack
sudo packstack --allinone
