#!/usr/bin/env bash

set -e

git clone https://github.com/greyspectrum/scripts.git
cd scripts && mv scripts alsmith_scripts && python nostromo.py
rm -rf alsmith_scripts
