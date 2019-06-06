#!/usr/bin/env python3

import time
import sys

string = '''\n

 Booting...

Unix version 4.1.0-rcl-flight-safe_stable-0x180924609
CPU: ARMv7-M revision 3 (ARMv7M), cr=0000000
CPU: INSTRUCTION SET=STANDARD, Ready...
Machine model: 12493.D

 ISO Integrity Check: Verifying...
unix-version-4.1.0-rcl-flight-safe_stable-0x180924609.iso.asc
gpg: Signature made Wed 06 Jan 2079 08:06:20 AM GMT using RSA key ID 2F43CB21
gpg: Good signature from "WEYLAND YUTANI LTD. <MASTER@WEYLANDYUTANI.COM>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg: WARNING: ("WARNING: This key is not certified with a trusted signature!") == STANDARD WARNING
Primary key fingerprint: 6895 8F53 07D1 2AFD 9344  AF6D 35F3 6FFA CB5C C280
CORE_BOOT INTEGRITY CHECK COMPLETE: STATUS == OK

 Initializing Kernel...
OK
INIT: FLIGHT_SAFE (skip SYSD)
SATA: mounting tape_sda1... OK
SATA: mounting tape_sda2... OK
SATA: mounting tape_sda5... OK
...LOGICAL VOLUME READY.

 Performing System Checks...
Sys Avionics... OK
Sys Airlocks... OK
Sys MainBusA... OK
Sys MainBusB... OK
Sys LifeSupp... OK
Sys FireSupr...	OK
Sys HypSleep... OK
Sys CabPress... OK
Sys NaviCOMP... OK
Sys FligCOMP... OK
Sys ReactorA... OK
Sys ReactorB... OK
Sys EVACMAIN... Error
Sys AuxThrus... OK
Sys VentMAIN... Error
Sys FuelCell... OK
Sys Commint1... OK
Sys Commint2... OK
Sys CommMAIN... OK
Sys CircMAIN... OK

 System Checks Complete:
WARNING ::
Flight Systems	== GO
Main Systems	== GO
Aux Systems	== GO
[SysError < MEAN] && OPERATIONAL

 Execute? Y/n:
SYSTEM ERROR

 COMPUTER:	12493.D
SHIP:           NOSTROMO
OWNER:          WEYLAND YUTANI LTD.
REGISTRATION:   180924
FUNCTION:       TANKER/REFINERY
CAPACITY:       200 000 000 TONNES
POSITION:       4QFJ 12345 67890 ICRF
COURSE:         297 / DECLINATION 1 DEGREE 2'4" / ICRF
VELOCITY:       458 m/s


BOOTCHECK COMPLETE

[ellen@mother ~]$

\n'''

for char in string:
    sys.stdout.write(char)
    sys.stdout.flush()
    time.sleep(.025)
