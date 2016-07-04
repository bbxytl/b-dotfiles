#!/usr/bin/env python
# encoding: utf-8
# coding style: pep8
# ====================================================
#   Copyright (C)2016 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : get_name.py
#   Last Modified : 2016-07-04 11:42
#   Describe      :
#
#   Log           :
#
# ====================================================

import sys
# import os
args = sys.argv
print args
path = args[1]
Host_Name = args[2]
config = open(path, 'r')
line = config.readline()
preline = ""
while line:
	line.strip()
	# print line
	hostname = line[9:].lower().strip()
	if hostname == Host_Name:
		print preline.strip()
		break
	preline = line
	line = config.readline()

