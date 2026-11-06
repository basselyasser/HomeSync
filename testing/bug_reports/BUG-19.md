# BUG-19: Two screens share the same route id

**Severity:** Low  
**Related tests:** SD-12 (code review)  
**Build:** commit `d9b139f` (main, 5 Nov 2026)  
**Found by:** code-level execution (`testing/static_checks.py`). Confirm on a device before closing.

## Steps to reproduce
1. Compare SwitchScreen.id and SmartPlugControlScreen.id

## Expected result
Unique ids

## Actual result
Both 'smartplugcontrolscreen'

## Code location
[lib/views/screens/switch_screen.dart:17](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/switch_screen.dart#L17)
