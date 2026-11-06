# BUG-03: Login shows 'Something went wrong' for invalid email, no internet and (likely) wrong credentials

- Severity: Medium
- Related tests: TC-LOG-04, TC-LOG-14, TC-LOG-08, TC-LOG-09, SD-03
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Enter 'test@' and a 6+ char password
2. Tap LOGIN

## Expected result
Clear message (invalid email / no connection / invalid email or password)

## Actual result
Generic 'Something went wrong'. Only 'user-not-found' and 'wrong-password' codes are handled

## Code location
[lib/views/screens/login_screen.dart:45](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/login_screen.dart#L45)
