# BUG-06: Predicted usage is doubled

- Severity: Low
- Related tests: TC-HOME-04, SD-09
- Build: commit `d9b139f` (main, 5 Nov 2026)
- Found by: code review (see `testing/static_checks.py`). To be confirmed on a device.

## Steps to reproduce
1. Call GET /predict-electricity and note X
2. Open Bill Prediction

## Expected result
Predicted Usage = X

## Actual result
Predicted Usage = 2X (the code multiplies the value by 2). Confirm intent with the team

## Code location
[lib/providers/prediction_provider.dart:28](https://github.com/basselyasser/HomeSync/blob/d9b139f0f0788d304d65f0fc62f66571647c49d9/lib/providers/prediction_provider.dart#L28)
