#!/usr/bin/env python3

import subprocess
import sys


def parse_time(t):
    ti, _ = t.split(maxsplit=1)
    return int(ti)


def main():
    count = 0
    for file in sys.argv[1:]:
        out = subprocess.run(['mediainfo', file],
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

        count += parse_time(d.get('Duration'))
    print(count)


main()
