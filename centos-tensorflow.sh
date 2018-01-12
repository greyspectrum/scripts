#!/usr/bin/env bash

# Adapted from: https://gist.github.com/thoolihan/28679cd8156744a62f88

sudo yum -y install epel-release
sudo yum -y install gcc gcc-c++ python-pip python-devel atlas atlas-devel gcc-gfortran openssl-devel libffi-devel
# use pip or pip3 as you prefer for python or python3
sudo pip install --upgrade virtualenv
virtualenv --system-site-packages ~/venvs/tensorflow
source ~/venvs/tensorflow/bin/activate
sudo pip install --upgrade numpy scipy wheel cryptography

read -p "Do you need support for GPUs? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo pip install --upgrade tensorflow-gpu
else
    sudo pip install --upgrade tensorflow
fi
