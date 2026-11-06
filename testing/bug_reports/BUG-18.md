# BUG-18: Firestore database is open to anyone

**Severity:** High  
**Related tests:** SD-13 (code review)  
**Build:** commit `d9b139f` (main, 5 Nov 2026)  
**Found by:** code-level execution (`testing/static_checks.py`). Confirm on a device before closing.

## Steps to reproduce
1. Open firestore.rules

## Expected result
Only signed-in users can read/write their data

## Actual result
allow read, write: if true

## Code location
[firestore.rules:6](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/firestore.rules#L6)
