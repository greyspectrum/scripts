#!/usr/bin/python

import glob
import os

list_of_snapshots = glob.glob('/srv/backup/*')
latest_snapshot = max(list_of_snapshots, key=os.path.getctime)
print latest_snapshot.split("/")[-1]
