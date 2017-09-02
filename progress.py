#!/usr/bin/env python

import os
import sys
from subprocess import check_output
import re

W  = '\033[0m'  # white (normal)
R  = '\033[31m' # red
G  = '\033[32m' # green
O  = '\033[33m' # orange
B  = '\033[34m' # blue
P  = '\033[35m' # purple

du = check_output('du -s --block-size=1G', shell=True)
duhuman = check_output('du -sh', shell=True)
print "\n{}------------------------------TRANSFER PROGRESS------------------------------{}\n".format(G, W)
print "THE SIZE OF THIS DIRECTORY IS: " + duhuman

n1 = re.search('\d+(?:\.\d+)?', du).group(0)

n2 = 3800

def percentage(part, whole):
    return 100 * float(part)/float(whole)

print "THE TRANSFER IS: " + str(percentage(n1, n2)) + "% COMPLETED"
