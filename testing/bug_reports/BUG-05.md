# BUG-05: Register: backend error is not handled

- Severity: Medium
- Related tests: TC-REG-01
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Stop the backend
2. Register a new account

## Expected result
Error message; no half-created account

## Actual result
Firebase account is created, POST /users/ fails, exception is not caught, no message

## Code location
[lib/views/screens/register_screen.dart:66](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/register_screen.dart#L66)
