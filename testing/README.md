# HomeSync Test Report (Cycle 1)

Tester: Bassel Yasser Shaker
Date: 6 November 2026
Build tested: main branch, commit [d9b139f](https://github.com/basselyasser/HomeSync/commit/d9b139f0f0788d304d65f0fc62f66571647c49d9)

## Files in this folder

- `HomeSync_Test_Cases.xlsx`: all test cases with their results
- `code_checks.py`: script used to check each result against the code
- `code_checks_output.txt`: output of the script
- `bug_reports/`: one file per bug found

## Scope

I wrote 61 manual test cases for the mobile app and 22 API test cases for the backend. The manual cases cover app launch, login, registration, forgot password, the home screen, rooms, devices, switches, the smart plug, the air conditioner, the servo, automation rules and the server IP setting. I also listed 13 suspected defects that I noticed while reading the code, each linked to the test that would confirm it.

Test design techniques used: equivalence partitioning, boundary value analysis, decision tables, state transition, use cases and error guessing.

## How the tests were run

The backend server, Firebase project, Home Assistant and ESP32 hardware were not available for this cycle, so I ran the tests at code level. For each test case I traced the steps through the Flutter code and compared what the code does with the expected result.

I marked a test as Pass or Fail only when the code alone decides the result, for example form validation, navigation, or a button that has no handler. When the result depends on the server or the hardware, I marked it as Blocked and wrote down what the code shows.

To make the results easy to check, `code_checks.py` searches for the line of code behind each verdict and prints the file name and line number. You can run it from the repository root:

```
python testing/code_checks.py
```

After a bug is fixed, the related test changes from FAIL to PASS in the output.

## Results

| Sheet | Total | Pass | Fail | Blocked |
|---|---|---|---|---|
| Manual test cases | 61 | 23 | 22 | 16 |
| API test cases | 22 | 0 | 0 | 22 |
| Total | 83 | 23 | 22 | 38 |

Pass rate is 51% (passed tests out of passed and failed tests; blocked tests are not counted). All API tests are blocked because the backend code is not in this repository.

12 of the 13 suspected defects were confirmed in the code. SD-08 needs API-16 to be run against the backend.

## Main findings

I logged 20 bugs: 6 high, 6 medium and 8 low.

The high severity bugs are:

- BUG-01: the app opens on the Home screen and skips the splash and login screens.
- BUG-08: the Rooms and All Devices screens cannot be opened from the app and show no data.
- BUG-11: tapping the smart plug does not change its state.
- BUG-12: the air conditioner sliders and mode buttons do not respond.
- BUG-13: the air conditioner power button sends no command.
- BUG-18: the Firestore database rules allow anyone to read and write.

The medium bugs cover unclear login error messages, the forgot password screen not working, unhandled backend errors on registration and switch toggling, the rule screen overwriting a saved threshold, and the server IP being hard-coded. Full details are in `bug_reports/`.

The areas that work as expected in the code are login and registration form validation, password masking, protection against double taps, logout, the weather error message, servo error handling and the automation rule slider ranges.

## Next steps

1. Run the 38 blocked tests on an Android device with the backend, Firebase, Home Assistant and ESP32 running, and run the API tests in Postman.
2. Confirm each bug on a device and add a screenshot before reporting it as a GitHub issue.
3. Retest after the fixes and run `code_checks.py` again.
