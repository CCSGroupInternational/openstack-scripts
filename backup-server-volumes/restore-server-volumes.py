#!/bin/python

from __future__ import print_function
import sys

if sys.version_info[0] < 3:
	from commands import getstatusoutput
else:
	from subprocess import getstatusoutput

print("Bacing up")