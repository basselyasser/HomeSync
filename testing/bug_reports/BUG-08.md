# BUG-08: Rooms and All Devices screens cannot be opened and show no data

- Severity: High
- Related tests: TC-ROOM-01, TC-ROOM-02, TC-DEV-01, SD-07
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/code_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Log in
2. Look for a way to open All Rooms / All Devices

## Expected result
User sees their rooms and devices; new rooms appear

## Actual result
No navigation to RoomsPage; rooms list hard-coded empty and never loaded; Devices grid empty; create sends 'user_id' but list filters on 'user'

## Code location
[lib/views/screens/rooms_screen.dart:16](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/rooms_screen.dart#L16)
