#!/usr/bin/env python3

import subprocess
import sys

out = subprocess.run(['mediainfo', sys.argv[1]],
                     stdout=subprocess.PIPE,
                     stderr=subprocess.STDOUT,
                     universal_newlines=True)


d = {}
for line in out.stdout.split('\n'):
    line = line.split(':')
    if len(line) == 2:
        d[line[0].strip()] = line[1].strip()
    else:
        continue


for key, value in d.items():
    print(key, ':', value)
