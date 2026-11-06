# BUG-20: README refers to files that are not in the repo

- Severity: Low
- Related tests: Documentation review
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/code_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Follow 'How to run' step 3
2. Check the Screenshots section

## Expected result
Files exist

## Actual result
secrets.example.dart and screenshots/ are missing; OTP verification is listed but no screen uses it

## Code location
[README.md:55](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/README.md#L55)
