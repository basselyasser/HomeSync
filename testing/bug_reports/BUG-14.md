# BUG-14: Rule screen does not show the saved threshold and can overwrite it

**Severity:** Medium  
**Related tests:** TC-RULE-03 (extra finding)  
**Build:** commit `d9b139f` (main, 5 Nov 2026)  
**Found by:** code-level execution (`testing/static_checks.py`). Confirm on a device before closing.

## Steps to reproduce
1. Save a temperature rule at 30
2. Leave and reopen the screen
3. Tap Save without moving the slider

## Expected result
Slider starts at 30

## Actual result
Slider shows the midpoint (20); Save overwrites the rule with 20

## Code location
[lib/views/screens/sensor_rule_screen.dart:52](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/sensor_rule_screen.dart#L52)
