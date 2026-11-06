# Bug reports

Each file is ready to paste into a new GitHub issue (title = first line, body = the rest).

| Bug | Title | Severity | Related tests |
|---|---|---|---|
| [BUG-01](BUG-01.md) | App opens on Home instead of splash / login | High | TC-NAV-01, SD-01 |
| [BUG-02](BUG-02.md) | Splash screen 1 is never shown | Low | TC-NAV-02 |
| [BUG-03](BUG-03.md) | Login shows 'Something went wrong' for invalid email, no internet and (likely) wrong credentials | Medium | TC-LOG-04, TC-LOG-14, TC-LOG-08, TC-LOG-09, SD-03 |
| [BUG-04](BUG-04.md) | Forgot password has no entry point and SUBMIT does nothing | Medium | TC-PWD-01, TC-PWD-02, SD-04 |
| [BUG-05](BUG-05.md) | Register: backend error is not handled | Medium | TC-REG-01 |
| [BUG-06](BUG-06.md) | Predicted usage is doubled | Low | TC-HOME-04, SD-09 |
| [BUG-07](BUG-07.md) | Back on Home returns to Login while still signed in | Low | TC-HOME-05 (extra finding) |
| [BUG-08](BUG-08.md) | Rooms and All Devices screens cannot be opened and show no data | High | TC-ROOM-01, TC-ROOM-02, TC-DEV-01, SD-07 |
| [BUG-09](BUG-09.md) | Empty or blank room name gives no feedback | Low | TC-ROOM-03, TC-ROOM-04, SD-06 |
| [BUG-10](BUG-10.md) | Switch toggle failure shows no error | Medium | TC-SW-03 |
| [BUG-11](BUG-11.md) | Smart plug tap does not change its state | High | TC-PLUG-01, SD-05 |
| [BUG-12](BUG-12.md) | Air conditioner controls do not respond | High | TC-AC-01 to TC-AC-04 |
| [BUG-13](BUG-13.md) | AC power button sends no command and always says 'Off' | High | TC-AC-05, SD-02 |
| [BUG-14](BUG-14.md) | Rule screen does not show the saved threshold and can overwrite it | Medium | TC-RULE-03 (extra finding) |
| [BUG-15](BUG-15.md) | Failed rule save shows no message | Low | TC-RULE-06, SD-10 |
| [BUG-16](BUG-16.md) | Server IP setting cannot be opened and is ignored; backend IP is hard-coded | Medium | TC-IP-01, TC-SW-04 |
| [BUG-17](BUG-17.md) | Server IP is not validated | Low | TC-IP-02, SD-11 |
| [BUG-18](BUG-18.md) | Firestore database is open to anyone | High | SD-13 (code review) |
| [BUG-19](BUG-19.md) | Two screens share the same route id | Low | SD-12 (code review) |
| [BUG-20](BUG-20.md) | README refers to files that are not in the repo | Low | Documentation review |
