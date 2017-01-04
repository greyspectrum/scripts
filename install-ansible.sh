#!/usr/bin/env bash

##############################################################################
# install-ansible
# -----------------
#
# :author: greyspectrum
# :date: 3 January 2017
# :version: 0.1.0
##############################################################################

# Perhaps it is ironic to use a bash script to install Ansible, but if Ansible
# orchestrates all who are not Ansible, who orchestrates Ansible?
#
# To get started, copy this file to your remote host where you want to install Ansible,
# using the following command:
#
# scp ~/pathtoscript/install-ansible.sh root@remoteip:install-ansible.sh
#
# Be sure to replace "pathtoscript" with the path to this script on your local machine,
# as well as "remoteip", which should be replaced with the IP address of the remote host.
#
# After you have copied the file to the remote host, just ssh to it and run this script.

echo "Starting Ansible Installation..."

sudo apt-get update
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:rquillo/ansible
sudo apt-get update
sudo apt-get install ansible
