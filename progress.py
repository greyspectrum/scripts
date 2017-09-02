#!/usr/bin/env python

import os
import sys
from subprocess import check_output
import re

du = check_output('du -s --block-size=1G', shell=True)
duhuman = check_output('du -sh', shell=True)
print "\n------------------------------TRANSFER PROGRESS------------------------------\n"
print "THE SIZE OF THIS DIRECTORY IS: " + duhuman

n1 = re.search('\d+(?:\.\d+)?', du).group(0)

n2 = 3800

def percentage(part, whole):
    return 100 * float(part)/float(whole)

print "THE TRANSFER IS: " + str(percentage(n1, n2)) + "% COMPLETED"
