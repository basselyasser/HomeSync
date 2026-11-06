# BUG-01: App opens on Home instead of splash / login

- Severity: High
- Related tests: TC-NAV-01, SD-01
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Install the app
2. Open it while logged out

## Expected result
Splash, then Login

## Actual result
Home opens directly; login is skipped

## Code location
[lib/main.dart:46](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/main.dart#L46)
