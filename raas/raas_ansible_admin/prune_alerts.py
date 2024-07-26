#!/usr/bin/env python

import sys, json

data = json.load(sys.stdin)
res = {k: v for k, v in data.iteritems() if v['enabled']}

for k, v in res.iteritems():
  v.pop('change_time', None)
  v.pop('change_value', None)
  v.pop('state', None)
  v.pop('severity', None)

print json.dumps(res, sort_keys=True, indent=2, separators=(',', ': '))