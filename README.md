## Notes:

### combining old and new 500 data:
before:
- 1117 old entries
- 485 new entries

- 36 ip's in common
- 1081 in old, but not in new

after:
- 1566 in new

### kicking out bad data
remove sessions that hit shutdown times (12am, 6am, 12pm, 6pm)
- 32 kicked out
  - 8 from 300
  - 12 from 400
  - 5 from 500
  - 7 from 600

remove sessions longer than 20 min
- 64 kicked out

total:
- 96 kicked out
  - 31 from 300
  - 31 from 400
  - 16 from 500
  - 26 from 600
