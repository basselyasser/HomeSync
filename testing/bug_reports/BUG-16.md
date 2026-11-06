# BUG-16: Server IP setting cannot be opened and is ignored; backend IP is hard-coded

**Severity:** Medium  
**Related tests:** TC-IP-01, TC-SW-04  
**Build:** commit `d9b139f` (main, 5 Nov 2026)  
**Found by:** code-level execution (`testing/static_checks.py`). Confirm on a device before closing.

## Steps to reproduce
1. Look for the server IP setting
2. Run the app on a network where the backend is not 192.168.151.76

## Expected result
User can set the IP and the app uses it

## Actual result
Dialog never opened; IP hard-coded in 4 files

## Code location
[lib/services/api_service.dart:16](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/services/api_service.dart#L16)
