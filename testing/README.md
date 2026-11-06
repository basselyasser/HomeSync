# HomeSync – Test Execution Report

| | |
|---|---|
| **Build tested** | `main` @ [`d9b139f`](https://github.com/basselyasser/HomeSync/commit/d9b139f0f0788d304d65f0fc62f66571647c49d9) (5 Nov 2026) |
| **Test cycle** | Cycle 1, 6 Nov 2026 |
| **Tester** | Bassel Yasser Shaker |
| **Test cases** | [HomeSync_Test_Cases_Executed.xlsx](HomeSync_Test_Cases_Executed.xlsx) |
| **Evidence** | [evidence/static_check_results.txt](evidence/static_check_results.txt) (produced by [static_checks.py](static_checks.py)) |
| **Bugs** | [bug_reports/](bug_reports/README.md) (20 reports, ready to file as GitHub issues) |

## Scope

- **Manual test cases (61):** app launch, login, register, forgot password, home, rooms, devices, switch, smart plug, air conditioner, servo, automation rules, server IP setting.
- **API test cases (22):** backend REST endpoints, to run with Postman.
- **Suspected defects (13):** problems spotted while reading the code, each linked to the test that confirms it.

Test design techniques used: equivalence partitioning, boundary value analysis, decision table, state transition, use case and error guessing (shown per test in the *Design Technique* column).

## How the tests were executed

This cycle was run at **code level**, without a phone or the backend:

1. Each test case was traced through the Flutter source to the code that decides its result.
2. Every verdict is backed by a check in `static_checks.py`. Each check searches for the exact line that makes the test pass or fail and prints `file:line`.
3. **Pass / Fail** is used only where the code alone decides the result (form validation, navigation, missing or empty handlers, widgets that never update).
4. **Blocked** is used where the result depends on the backend server, the Firebase project, Home Assistant or the ESP32 hardware. The backend code is not in this repository, so all 22 API tests are Blocked. Code observations are still written in *Actual Result*.

To re-run the evidence after a fix:

```
python testing/static_checks.py > testing/evidence/static_check_results.txt
```

A fixed bug turns its test from `FAIL` to `PASS` in the output.

## Results

| Sheet | Total | Pass | Fail | Blocked | Pass rate* |
|---|---|---|---|---|---|
| Manual Test Cases | 61 | 23 | 22 | 16 | 51% |
| API Test Cases | 22 | 0 | 0 | 22 | – |
| **Total** | **83** | **23** | **22** | **38** | **51%** |

\* Pass ÷ (Pass + Fail). Blocked cases are left out.

**Suspected defects:** 12 of 13 confirmed in code. SD-08 (backend returns every user's rooms) waits for API-16.

## Main findings

| Severity | Bugs |
|---|---|
| High (6) | BUG-01 app skips splash and login · BUG-08 Rooms / All Devices cannot be opened and show no data · BUG-11 smart plug does nothing · BUG-12 AC controls do not move · BUG-13 AC power sends no command · BUG-18 Firestore open to anyone |
| Medium (6) | BUG-03 generic login errors · BUG-04 forgot password not working · BUG-05 register ignores backend errors · BUG-10 switch errors not shown · BUG-14 rule screen overwrites the saved threshold · BUG-16 server IP hard-coded |
| Low (8) | BUG-02, BUG-06, BUG-07, BUG-09, BUG-15, BUG-17, BUG-19, BUG-20 |

Working well in code: all login and register form validation and boundaries, password masking, double-tap protection, logout, weather error handling, servo error handling and the automation rule slider ranges.

## Open items for the next cycle

1. Run the 38 Blocked cases on an Android phone with the backend, Firebase, Home Assistant and ESP32 running. Use the Postman collection for the API sheet.
2. Confirm each bug on a device, add a screenshot or screen recording, and file it as a GitHub issue. Then put the issue number in the *Bug ID* column.
3. Retest after fixes and re-run `static_checks.py`.
