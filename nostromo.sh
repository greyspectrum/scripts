#!/usr/bin/env bash

set -e

git clone https://github.com/greyspectrum/scripts.git
mv scripts alsmith_scripts && cd alsmith_scripts && python nostromo.py
rm -rf alsmith_scripts
