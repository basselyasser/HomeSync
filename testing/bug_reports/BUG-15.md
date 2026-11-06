# BUG-15: Failed rule save shows no message

- Severity: Low
- Related tests: TC-RULE-06, SD-10
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Stop the backend
2. Tap Save on a rule

## Expected result
Error message

## Actual result
Only a debug log line

## Code location
[lib/views/screens/sensor_rule_screen.dart:99](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/sensor_rule_screen.dart#L99)
