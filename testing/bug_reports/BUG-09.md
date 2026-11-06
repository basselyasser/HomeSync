# BUG-09: Empty or blank room name gives no feedback

**Severity:** Low  
**Related tests:** TC-ROOM-03, TC-ROOM-04, SD-06  
**Build:** commit `d9b139f` (main, 5 Nov 2026)  
**Found by:** code-level execution (`testing/static_checks.py`). Confirm on a device before closing.

## Steps to reproduce
1. Open Create New Room
2. Leave name empty or spaces
3. Tap Save

## Expected result
Validation message

## Actual result
Nothing happens; dialog stays open

## Code location
[lib/views/screens/rooms_screen.dart:25](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/rooms_screen.dart#L25)
