# BUG-11: Smart plug tap does not change its state

- Severity: High
- Related tests: TC-PLUG-01, SD-05
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Open Smart Plug
2. Tap the power button

## Expected result
Plug toggles; UI changes

## Actual result
API call commented out; only a 50 ms message

## Code location
[lib/views/screens/smart_plug_screen.dart:74](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/smart_plug_screen.dart#L74)
