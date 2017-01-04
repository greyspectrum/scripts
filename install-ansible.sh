#!/usr/bin/env bash

##############################################################################
# install-ansible
# -----------------
# An Ansible installation script, for DigitalOcean.
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

# Install Ansible:

sudo apt-get update
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:rquillo/ansible
sudo apt-get update
sudo apt-get install ansible

# Create SSH keys on the remote host:

SSH_CONFIG="/etc/ssh/ssh_config"

BACKUP_SSH_CONFIG="/etc/ssh/ssh_config.bak"

SECURE_SSH_CONFIG="/etc/ssh/ssh_config.secure"

MODULI="/etc/ssh/moduli"

BACKUP_MODULI="/etc/ssh/moduli.bak"

ALL_MODULI="/etc/ssh/moduli.all"

SAFE_MODULI="/etc/ssh/moduli.safe"

# Prompt the user for root

[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Backup current ssh configuration file

cp $SSH_CONFIG $BACKUP_SSH_CONFIG

# Create new ssh config file

echo -e "    PasswordAuthentication no \n    ChallengeResponseAuthentication no \n    Host * \n          PasswordAuthentication no \n          ChallengeResponseAuthentication no \n    PubkeyAuthentication yes \n    Host * \n           PubkeyAuthentication yes \n           HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa \n    KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256 \n#   Github needs diffie-hellman-group-exchange-sha1 some of the time but not always. \n    Host github.com \n           KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1 \n    Host * \n           KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256 \n    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr \n    Host * \n           Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr \n    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com \n    Host * \n           MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com \n    HashKnownHosts yes \n    UseRoaming no \n    Host * \n           UseRoaming no" > $SECURE_SSH_CONFIG

# Remove prime numbers with size in bits < 2000

if test -e $MODULI ; then
	cp $MODULI $BACKUP_MODULI
	awk '$5 > 2000' $MODULI > "${HOME}/moduli"
	wc -l "${HOME}/moduli" # make sure there is something left
	mv "${HOME}/moduli" $MODULI
else
	ssh-keygen -G $ALL_MODULI -b 4096
	ssh-keygen -T $SAFE_MODULI -f $ALL_MODULI
	mv $SAFE_MODULI $MODULI
	rm $ALL_MODULI
fi

# Commit changes

mv $SECURE_SSH_CONFIG $SSH_CONFIG

# Generate client ssh keys

ssh-keygen -t ed25519 -o -a 100
ssh-keygen -t rsa -b 4096 -o -a 100

echo -e "Your new keys are available in your user's ~/.ssh directory. The public key (the one you can share) is called id_rsa.pub. The private key (the one that you keep secure) is called id_rsa.\nYou can add them to your DigitalOcean control panel to allow you to embed your SSH key into newly created droplets. This will allow your Ansible droplet to SSH into your new droplets immediately, without any other authentication.\nTo do this, click on the "SSH Keys" link at: https://cloud.digitalocean.com/settings/security\nEnter the name you want associated with this key into the top field, then copy your public key (displayed below) into the second field in the DigitalOcean control panel."

cat ~/.ssh/id_rsa.pub

echo "Now, in the DigitalOcean control panel, click "Create SSH Key" to add your key to the control panel. Now, whenever you create a new droplet, you will be able to embed your public SSH key into the new server, allowing you to communicate with your Ansible instance. You just need to select the key in the "Add optional SSH Keys" section of the droplet creation process."
