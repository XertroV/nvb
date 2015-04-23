import sys
from collections import defaultdict

rows = []

for l in sys.stdin.readlines():
  if len(l) > 0:
    rows.append(l[:-1].split(','))

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
p_list.sort()

print(table)

print('', sep=',', *s_list)
  
for p in p_list:
  print(p, sep=',', *map(lambda s: table[s][p], s_list))
