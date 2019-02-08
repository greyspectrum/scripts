#!/usr/bin/python

import os
import datetime
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("retention", help="backup retention, in days", type=int)
args = parser.parse_args()
path_backup = "/srv/backup"
now = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
old = int(now) - args.retention * 1000000
snapshots = os.listdir(path_backup)
timestamps = [s.strip('consul-bakpsp.') for s in snapshots]

def failsafe():

    if len(snapshots) < args.retention * 24:
        exit(0)

def cull():

    for x, y in zip(timestamps, snapshots):
        if old > int(x):
            os.remove(os.path.join(path_backup, y))

failsafe()
cull()
