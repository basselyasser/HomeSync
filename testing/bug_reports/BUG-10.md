# BUG-10: Switch toggle failure shows no error

- Severity: Medium
- Related tests: TC-SW-03
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Stop the backend
2. Toggle a switch

## Expected result
Error message

## Actual result
No message; unhandled exception

## Code location
[lib/views/screens/switch_screen.dart:98](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/switch_screen.dart#L98)
