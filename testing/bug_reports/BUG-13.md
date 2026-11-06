# BUG-13: AC power button sends no command and always says 'Off'

- Severity: High
- Related tests: TC-AC-05, SD-02
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Open Air Conditioner
2. Tap Power twice

## Expected result
AC receives settings; message alternates On/Off

## Actual result
No API call; message always 'Off'

## Code location
[lib/views/screens/ac_slider_screen.dart:186](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/ac_slider_screen.dart#L186)
