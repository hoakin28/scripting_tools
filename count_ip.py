#!/usr/bin/python

from collections import defaultdict
import re
import sys

d= defaultdict(int)

try:
    with open(sys.argv[1], 'r') as f:
        for row in f:
            ip=re.findall("((?:[0-9]{1,3}\.){3}[0-9]{1,3})", row)
            for i in ip:
                d[i] += 1
except IOError as error:
    print(error)

for key, value in sorted(d.items(), key=lambda x: x[1], reverse=True):
    print('IP: %s COUNT: %s' % (key,value))
