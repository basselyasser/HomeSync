# BUG-02: Splash screen 1 is never shown

- Severity: Low
- Related tests: TC-NAV-02
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Open the app

## Expected result
Splash 1, then Splash 2, then Login

## Actual result
Splash 1 is never reached; app starts at Splash 2

## Code location
[lib/main.dart:65](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/main.dart#L65)
