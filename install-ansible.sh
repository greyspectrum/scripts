#!/usr/bin/env bash

##############################################################################
# install-ansible
# ---------------
# An Ansible installation script.
#
# If Ansible configures all who are not Ansible, who configures Ansible?
#
# :author: greyspectrum
# :date: 3 July 2017
# :version: 0.1.0
##############################################################################

cat << "EOF"

      ___           ___           ___                       ___           ___       ___
     /\  \         /\__\         /\  \          ___        /\  \         /\__\     /\  \    
    /::\  \       /::|  |       /::\  \        /\  \      /::\  \       /:/  /    /::\  \   
   /:/\:\  \     /:|:|  |      /:/\ \  \       \:\  \    /:/\:\  \     /:/  /    /:/\:\  \  
  /::\~\:\  \   /:/|:|  |__   _\:\~\ \  \      /::\__\  /::\~\:\__\   /:/  /    /::\~\:\  \ 
 /:/\:\ \:\__\ /:/ |:| /\__\ /\ \:\ \ \__\  __/:/\/__/ /:/\:\ \:|__| /:/__/    /:/\:\ \:\__\
 \/__\:\/:/  / \/__|:|/:/  / \:\ \:\ \/__/ /\/:/  /    \:\~\:\/:/  / \:\  \    \:\~\:\ \/__/
      \::/  /      |:/:/  /   \:\ \:\__\   \::/__/      \:\ \::/  /   \:\  \    \:\ \:\__\  
      /:/  /       |::/  /     \:\/:/  /    \:\__\       \:\/:/  /     \:\  \    \:\ \/__/  
     /:/  /        /:/  /       \::/  /      \/__/        \::/__/       \:\__\    \:\__\    
     \/__/         \/__/         \/__/                     ~~            \/__/     \/__/    

EOF

echo -e "\n\nWelcome to Ansible Setup!\n========================\n"
echo -e "\n\nConfiguring SSH...\n========================\n"

# Define variables (edit these if you want to test this script without altering your ssh_config)

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

echo -e "\n\nGenerating SSH keypair...\n========================\n"
ssh-keygen -t ed25519 -o -a 100
ssh-keygen -t rsa -b 4096 -o -a 100

#Enable firewall

echo -e "\n\nEnabling firewall...\n========================\n"
ufw allow OpenSSH
ufw --force enable
ufw status

# Add new user

# echo -e "\n\nAdding a new user...\n========================\n"
# echo "Enter a name to create a user: "
# read user
# adduser $user
# usermod -aG sudo $user
# sudo su - $user

echo -e "\n\nStarting Ansible Installation...\n================================="

# Install Ansible:

echo -e "\n\nUpdating apt cache...\n"
sudo apt-get update

echo -e "\n\nInstalling dependencies...\n"
sudo apt-get install python-software-properties -y

echo -e "\n\nAdding the Ansible apt repository...\n"
sudo add-apt-repository ppa:rquillo/ansible -y

echo -e "\n\nInstalling Ansible...\n"
sudo apt-get update
sudo apt-get install ansible -y

echo -e "\n\n==> DONE!\n"
