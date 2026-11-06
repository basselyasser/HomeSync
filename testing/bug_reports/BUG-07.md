# BUG-07: Back on Home returns to Login while still signed in

- Severity: Low
- Related tests: TC-HOME-05 (extra finding)
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/code_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Log in
2. Press the phone Back button on Home

## Expected result
App closes or stays on Home

## Actual result
Login screen is shown while the user is still signed in (Home opened with pushNamed)

## Code location
[lib/views/screens/login_screen.dart:43](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/login_screen.dart#L43)
