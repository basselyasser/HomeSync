# BUG-12: Air conditioner controls do not respond

- Severity: High
- Related tests: TC-AC-01 to TC-AC-04
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/code_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Open Air Conditioner
2. Drag the temperature slider / tap a mode / move fan speed

## Expected result
Values update on screen

## Actual result
Nothing moves: StatelessWidget changes fields without setState

## Code location
[lib/views/screens/ac_slider_screen.dart:4](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/views/screens/ac_slider_screen.dart#L4)
