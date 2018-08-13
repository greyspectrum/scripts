#!/usr/bin/env python3
import getpass
import hashlib
username = input('Username: ')
passwd = getpass.getpass('Password: ')
pghash = "md5" + hashlib.md5((passwd + username).encode('utf-8')).hexdigest()
print(pghash)
