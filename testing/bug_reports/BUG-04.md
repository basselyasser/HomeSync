# BUG-04: Forgot password has no entry point and SUBMIT does nothing

- Severity: Medium
- Related tests: TC-PWD-01, TC-PWD-02, SD-04
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Open Login and look for 'Forgot password?'
2. Open the screen directly and tap SUBMIT

## Expected result
Link exists; reset email is sent

## Actual result
No link; SUBMIT handler is empty and the form key is not attached to a Form

## Code location
[lib/views/screens/forget_password_screen.dart:88](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/forget_password_screen.dart#L88)
