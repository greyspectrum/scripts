#!/usr/bin/env bash

##############################################################################
# new-box
# -----------
# Configures SSH and enables the firewall for a new testing VM. 
#
# :author: greyspectrum
# :date: 3 July 2017
# :version: 0.1.0
##############################################################################

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

while true; do
    read -p "Would you like to generate ssh keys now? If you are running this script on a remote host, this is probably not necessary. [y/N] " yn
    case $yn in
        [Yy]* ) echo -e "\nGenerating keys...";
                ssh-keygen -t ed25519 -o -a 100;
                ssh-keygen -t rsa -b 4096 -o -a 100; break;;
        [Nn]* ) break;;
        * ) echo "Please answer y (yes) or n (no).";;
    esac
done

# Enable firewall

ufw allow OpenSSH
ufw enable
ufw status

echo -e "\n==> DONE!"
