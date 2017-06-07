# honssh-scripts
> A collection of python and shell scripts for analysis of honssh logs

## Motivation
Honssh keeps logs of all attacks on a honeypot. By parsing these logs, you can form generalizations about attacker location and behavior.

# Capabilities
* determine the length of attacker sessions
* determine how many bash commands were run during a sessions
* approximate attacker location using the DB-IP API
* consolidate data for each attacker

## Data
Format of `data/XXX_location.csv`:

Constant:
```
[directory],[ip],[continent],[country][# of sessions],[# of sessions without outliers]
```

Repeated for each session (excluding outliers):
```
[duration in seconds],[# of unix commands run]
```
