# BUG-17: Server IP is not validated

**Severity:** Low  
**Related tests:** TC-IP-02, SD-11  
**Build:** commit `d9b139f` (main, 5 Nov 2026)  
**Found by:** code-level execution (`testing/static_checks.py`). Confirm on a device before closing.

## Steps to reproduce
1. Open the IP dialog
2. Enter 'abc' and Save

## Expected result
Validation message

## Actual result
Saved as-is

## Code location
[lib/views/widgets/show_popup_ipaddress.dart:32](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/widgets/show_popup_ipaddress.dart#L32)
