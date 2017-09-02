#!/usr/bin/env python

#################################################
# PROGRESS ===>
#
# A lightweight script for measuring the progress
# of large data transfers between remote hosts.
#
# To use, specify the size of the data transfer
# as "n2", on line number 32.  
#
# Then, run this script in the target directory
# on the destination remote host. For continuous
# monitoring, you can employ watch to gather 
# measurements every two seconds:
#
# $ watch python progress.py
#################################################

import os
import sys
from subprocess import check_output
import re

du = check_output('du -s --block-size=1G', shell=True)
duhuman = check_output('du -sh', shell=True)
print "\n------------------------------TRANSFER PROGRESS------------------------------\n"
print "THE SIZE OF THIS DIRECTORY IS: " + duhuman

n1 = re.search('\d+(?:\.\d+)?', du).group(0)

n2 =    # Size of the data to be transfered, in gigabytes.

def percentage(part, whole):
    return 100 * float(part)/float(whole)

print "THE TRANSFER IS: " + str(percentage(n1, n2)) + "% COMPLETED"
