#!/usr/bin/env python3
import sys
from collections import defaultdict
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--spaces', help='Use spaces instead of commas as a delimiter', action='store_true')
args = parser.parse_args()

rows = []

for l in sys.stdin.readlines():
  if len(l) > 0:
    rows.append(l[:-1].split(','))

for l in rows:
  if l[3] == "5%":
    l[3] = "05%"

states = set(map(lambda l: l[2], rows))
particips = set(map(lambda l: l[3], rows))

table = defaultdict(lambda: {})

for l in rows:
  for s in states:
    for p in particips:
      if s == l[2] and p == l[3]:
        table[s][p] = float(l[0]) / float(l[1])

s_list = list(table.keys())
p_list = list(particips)
s_list.sort()
p_list.sort()

# print(table)

sep = ' ' if args.spaces else ','

print('_', sep=sep, *s_list)
  
for p in p_list:
  print(p[:-1], sep=sep, *map(lambda s: table[s][p], s_list))  # cut % off from p
