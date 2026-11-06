# HomeSync – Smart Home Mobile App

HomeSync is a Flutter mobile app for controlling a smart home through
[Home Assistant](https://www.home-assistant.io/). It was built as a graduation project
at the Arab Academy for Science, Technology and Maritime Transport (2025).

## Features

- Log in, register, verify your email with an OTP code and reset your password (Firebase Authentication)
- Rooms view with the devices in each room
- Control switches, smart plugs, the air conditioner (temperature slider) and servo motors
- Live sensor readings, updated in real time over Socket.IO
- Automation rules based on sensor values (for example, turn on the AC above 28 °C)
- Weather card
- Weekly electricity-consumption prediction from a machine-learning backend

## Screenshots

| Home | Rooms | Device control |
|------|-------|----------------|
| ![Home](screenshots/home.png) | ![Rooms](screenshots/rooms.png) | ![Device](screenshots/device.png) |

## Tech stack

| Area | Technology |
|------|------------|
| Mobile app | Flutter / Dart |
| State management | Riverpod (MVVM structure: models, view models, views, services) |
| Authentication and database | Firebase Authentication, Cloud Firestore |
| Smart home | Home Assistant REST API |
| Real-time updates | Socket.IO |
| Email OTP | SMTP (Mailjet) |

## Project structure

```
lib/
  configs/       app settings (secrets are kept in secrets.dart, not committed)
  models/        data classes (rooms, devices, users)
  view_models/   logic for the screens
  providers/     Riverpod providers
  repositories/  local storage (SharedPreferences)
  services/      Home Assistant API, Socket.IO and OTP services
  views/         screens and widgets
```

## How to run

1. Install [Flutter](https://docs.flutter.dev/get-started/install).
2. Clone the repository:
   ```
   git clone https://github.com/basselyasser/HomeSync.git
   cd HomeSync
   ```
3. Copy `lib/configs/secrets.example.dart` to `lib/configs/secrets.dart` and fill in your own
   Home Assistant token and SMTP details.
4. Install the packages and run the app:
   ```
   flutter pub get
   flutter run
   ```

## Testing

The app has 61 manual and 22 API test cases, designed with equivalence partitioning, boundary
value analysis, decision tables, state transition and error guessing.

- Test cases and results: [testing/HomeSync_Test_Cases_Executed.xlsx](testing/HomeSync_Test_Cases_Executed.xlsx)
- Test report: [testing/README.md](testing/README.md)
- Evidence: [testing/evidence/static_check_results.txt](testing/evidence/static_check_results.txt) (output of [testing/static_checks.py](testing/static_checks.py))
- Bug reports: [testing/bug_reports/](testing/bug_reports/README.md)

The first test cycle (6 November 2026, commit `d9b139f`) was run at code level. 23 tests passed,
22 failed and 38 were blocked because they need the backend or the hardware. 20 bugs were logged,
6 of them high severity. The blocked tests will be run on a device in the next cycle.

## Team

Graduation project team, Arab Academy for Science, Technology and Maritime Transport.

My part:

I designed and built the Home and Rooms screens in Flutter to monitor and operate all connected
devices in real time. I programmed the ESP32 to handle Wi-Fi communication and run local
automation rules that link sensors to actuators such as motors and lamps, and I integrated the
hardware and the mobile app with the Home Assistant API to keep device states in sync.

I was also responsible for testing. I wrote 83 test cases (61 manual and 22 API) covering login,
registration, rooms, device control, automation rules and the backend endpoints. I ran the first
test cycle at code level, checking each result against the source code, and logged 20 bugs with
steps to reproduce, expected and actual results, and links to the code. The test cases, report
and bug reports are in the [testing](testing/README.md) folder.
