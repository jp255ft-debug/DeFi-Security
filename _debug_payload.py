#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json, sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'scripts'))
os.environ['HACKERONE_TOKEN'] = 'test'
os.environ['HACKERONE_USERNAME'] = 'test'

from submit_to_hackerone import parse_findings_from_file, build_payload

findings = parse_findings_from_file('audits/Ripio/findings/high.md')
f = findings[0]
print('=== IMPACT ===')
print(repr(f['impact'][:300]))
print()
print('=== DESCRIPTION ===')
print(repr(f['description'][:300]))
print()
print('=== MITIGATION ===')
print(repr(f['mitigation'][:300]))
print()
print('=== CWE ===')
print(f['cwe'])
