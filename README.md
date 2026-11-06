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

The app was tested against 61 manual and 22 API test cases. They used equivalence partitioning,
boundary value analysis, decision tables, state transition and error guessing.

- Test cases and results: [testing/HomeSync_Test_Cases_Executed.xlsx](testing/HomeSync_Test_Cases_Executed.xlsx)
- Test report: [testing/README.md](testing/README.md)
- Evidence: [testing/evidence/static_check_results.txt](testing/evidence/static_check_results.txt), produced by [testing/static_checks.py](testing/static_checks.py)
- Bug reports: [testing/bug_reports/](testing/bug_reports/README.md)

Cycle 1 (6 Nov 2026, commit `d9b139f`) was run at code level: 23 passed, 22 failed and
38 were blocked because they need the backend or the hardware. It logged 20 bugs (6 high) and
confirmed 12 of 13 suspected defects. The blocked cases are planned for a device run.

## Team

Graduation project team, Arab Academy for Science, Technology and Maritime Transport.

My part:

- **Development:** designed and built the Home and Rooms screens in Flutter to monitor and
  operate all connected devices in real time. Programmed the ESP32 to handle Wi-Fi
  communication and run local automation rules that link sensors to actuators such as motors
  and lamps. Integrated the hardware and the mobile app with the Home Assistant API to keep
  device states in sync across the system.
- **Testing (QA):** wrote 83 test cases (61 manual, 22 API) covering login, registration,
  rooms, device control, automation rules and the backend endpoints. Ran test cycle 1 at code
  level with a small script that links every verdict to the exact line of code, then logged
  20 bugs with steps, expected and actual results, and GitHub links to the code. Results and
  evidence are in [testing/](testing/README.md).
