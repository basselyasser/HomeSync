"""
HomeSync code checks
====================
Runs the checks behind the "[Code review]" verdicts in
HomeSync_Test_Cases.xlsx. Each check looks for a specific line of code
and reports the file and line number, so every verdict can be traced to the source.

Usage (from the repository root):
    python testing/code_checks.py            # prints the report
    python testing/code_checks.py > testing/code_checks_output.txt

Check kinds:
    expect - the code needed for the expected result must be present
    defect - this code causes the defect; if it is found, the test fails

A test case PASSES when every 'expect' check is found and no 'defect' check is found.
Run it again after a fix: the related test should change from FAIL to PASS.
"""
import os
import re
import subprocess
import sys
from datetime import date

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

# (test case, kind, file, regex, what it means)
CHECKS = [
    # ---- App launch -------------------------------------------------------
    ("TC-NAV-01", "defect", "lib/main.dart", r"initialRoute:\s*HomeScreen\.id",
     "initialRoute is HomeScreen, which overrides home: SplashScreen2"),
    ("TC-NAV-02", "defect", "lib/main.dart", r"home:\s*const SplashScreen2\(\)",
     "App starts at SplashScreen2; nothing ever opens SplashScreen1"),
    ("TC-NAV-02", "expect", "lib/views/screens/splash_screen_2.dart",
     r"pushReplacementNamed\(context, LoginScreen\.id\)",
     "Splash 2 replaces itself with Login, so Back does not return to splash"),

    # ---- Login ------------------------------------------------------------
    ("TC-LOG-02", "expect", "lib/views/screens/login_screen.dart", r"'Please enter your email'", "Empty email message"),
    ("TC-LOG-02", "expect", "lib/views/screens/login_screen.dart", r"if \(!_formKey\.currentState!\.validate\(\)\) return;", "No request sent when the form is invalid"),
    ("TC-LOG-03", "expect", "lib/views/screens/login_screen.dart", r"if \(!value\.contains\('@'\)\) return 'Enter a valid email'", "Email without @ is rejected"),
    ("TC-LOG-04", "defect", "lib/views/screens/login_screen.dart", r"String message = 'Something went wrong';",
     "Only 'user-not-found' and 'wrong-password' are handled; invalid-email falls back to a generic message"),
    ("TC-LOG-05", "expect", "lib/views/screens/login_screen.dart", r"'Please enter your password'", "Empty password message"),
    ("TC-LOG-06", "expect", "lib/views/screens/login_screen.dart", r"if \(value\.length < 6\) return 'Password must be at least 6 characters'", "5 chars rejected"),
    ("TC-LOG-07", "expect", "lib/views/screens/login_screen.dart", r"value\.length < 6", "6 chars accepted (strictly less than 6 is rejected)"),
    ("TC-LOG-07", "expect", "lib/views/screens/login_screen.dart", r"signInWithEmailAndPassword", "Login request is sent after validation"),
    ("TC-LOG-08", "defect", "lib/views/screens/login_screen.dart", r"String message = 'Something went wrong';",
     "No handling for 'invalid-credential' (returned by Firebase when email enumeration protection is on)"),
    ("TC-LOG-09", "defect", "lib/views/screens/login_screen.dart", r"String message = 'Something went wrong';",
     "No handling for 'invalid-credential' (returned by Firebase when email enumeration protection is on)"),
    ("TC-LOG-10", "expect", "lib/views/screens/login_screen.dart", r"email: _emailController\.text\.trim\(\)", "Email is trimmed before login"),
    ("TC-LOG-11", "expect", "lib/views/screens/login_screen.dart", r"obscureText: isPassword", "Password field is masked"),
    ("TC-LOG-12", "expect", "lib/views/screens/login_screen.dart", r"onPressed: _isLoading \? null : _login", "Button disabled while loading"),
    ("TC-LOG-13", "expect", "lib/views/screens/login_screen.dart", r"pushNamed\(context, RegisterScreen\.id\)", "Sign up link opens Register"),
    ("TC-LOG-14", "defect", "lib/views/screens/login_screen.dart", r"String message = 'Something went wrong';",
     "'network-request-failed' is not handled; user sees a generic message"),
    ("TC-LOG-14", "expect", "lib/views/screens/login_screen.dart", r"finally \{\s*setState\(\(\) => _isLoading = false\)", "Spinner stops after an error"),

    # ---- Register ---------------------------------------------------------
    ("TC-REG-01", "defect", "lib/views/screens/register_screen.dart", r"\} on FirebaseAuthException catch \(e\) \{",
     "Only Firebase errors are caught; if POST /users/ fails, the error is unhandled (account exists in Firebase but not in the backend)"),
    ("TC-REG-02", "expect", "lib/views/screens/register_screen.dart", r"'Please enter a username'", "Empty username message"),
    ("TC-REG-03", "expect", "lib/views/screens/register_screen.dart", r"value\.length < 3", "Username under 3 chars rejected"),
    ("TC-REG-03", "expect", "lib/views/screens/register_screen.dart", r"'Username must be at least 3 characters'", "Username length message"),
    ("TC-REG-04", "expect", "lib/views/screens/register_screen.dart", r"value\.length < 3", "3 chars accepted"),
    ("TC-REG-05", "expect", "lib/views/screens/register_screen.dart", r"!value\.contains\('@'\)", "Email without @ rejected"),
    ("TC-REG-06", "expect", "lib/views/screens/register_screen.dart", r"value\.length < 6", "Password boundary is 6"),
    ("TC-REG-07", "expect", "lib/views/screens/register_screen.dart", r"'Passwords do not match'", "Mismatch message"),
    ("TC-REG-08", "expect", "lib/views/screens/register_screen.dart", r"_errorMessage = e\.message \?\? 'Registration failed'", "Firebase error text is shown"),
    ("TC-REG-08", "expect", "lib/views/screens/register_screen.dart", r"createUserWithEmailAndPassword[\s\S]*haService\.createUser",
     "Backend user is created only after Firebase succeeds, so no duplicate"),
    ("TC-REG-09", "expect", "lib/views/screens/register_screen.dart", r"pushNamed\(context, LoginScreen\.id\)", "Login link opens Login"),

    # ---- Forgot password --------------------------------------------------
    ("TC-PWD-01", "defect", "lib/views/screens/login_screen.dart", r"\A(?![\s\S]*ForgotPasswordScreen)",
     "Login screen has no link to ForgotPasswordScreen"),
    ("TC-PWD-02", "defect", "lib/views/screens/forget_password_screen.dart", r"// Handle password reset", "SUBMIT handler is empty"),
    ("TC-PWD-02", "defect", "lib/views/screens/forget_password_screen.dart", r"\A(?![\s\S]*Form\()",
     "_formKey is never attached to a Form, so validate() is never true"),

    # ---- Home -------------------------------------------------------------
    ("TC-HOME-03", "expect", "lib/views/screens/home_screen.dart", r"'Failed to load weather'", "Weather error text"),
    ("TC-HOME-03", "expect", "lib/services/api_service.dart", r'print\("Error fetching weather: \$e"\);\s*return null;', "Weather errors return null instead of crashing"),
    ("TC-HOME-04", "defect", "lib/providers/prediction_provider.dart", r"toDouble\(\) \* 2", "API value is multiplied by 2"),
    ("TC-HOME-04", "expect", "lib/views/screens/home_screen.dart", r"const double egpPerKwh = 1\.3;", "Cost rate 1.3 EGP/kWh"),
    ("TC-HOME-04", "expect", "lib/views/screens/home_screen.dart", r"egp\.toStringAsFixed\(2\)", "Cost shown with 2 decimals"),
    ("TC-HOME-05", "expect", "lib/views/screens/home_screen.dart", r"pushReplacementNamed\(context, LoginScreen\.id\)", "Logout replaces Home with Login"),
    ("TC-HOME-05", "defect", "lib/views/screens/login_screen.dart", r"Navigator\.pushNamed\(context, HomeScreen\.id\)",
     "(Extra finding, does not fail this case) Login pushes Home on top of Login, so Back on Home goes to Login while still signed in"),

    # ---- Rooms / Devices --------------------------------------------------
    ("TC-ROOM-01", "defect", "lib", r"RoomsPage\.id|RoomsPage\(\)",
     "No screen navigates to RoomsPage (only registered in main.dart routes)"),
    ("TC-ROOM-01", "defect", "lib/views/screens/rooms_screen.dart", r"final List<Room> rooms = \[\s*\];", "Rooms list is hard-coded empty"),
    ("TC-ROOM-01", "defect", "lib/views/screens/rooms_screen.dart", r"\A(?![\s\S]*fetchRooms)", "Rooms screen never calls fetchRooms()"),
    ("TC-ROOM-02", "defect", "lib/services/api_service.dart", r"'user_id': FirebaseAuth", "Create sends 'user_id'..."),
    ("TC-ROOM-02", "defect", "lib/services/api_service.dart", r"roomJson\['user'\] == uid", "...but the list filters on 'user'"),
    ("TC-ROOM-02", "defect", "lib/views/screens/rooms_screen.dart", r"\A(?![\s\S]*rooms\.add)", "New room is never added to the list after create"),
    ("TC-ROOM-03", "defect", "lib/views/screens/rooms_screen.dart", r"if \(roomName\.isEmpty\) return;", "Empty name returns silently"),
    ("TC-ROOM-04", "defect", "lib/views/screens/rooms_screen.dart", r"_roomNameController\.text\.trim\(\);\s*if \(roomName\.isEmpty\) return;", "Spaces-only name is trimmed, then returns silently"),
    ("TC-ROOM-06", "expect", "lib/views/screens/rooms_screen.dart", r"onPressed: \(\) => Navigator\.of\(context\)\.pop\(\),\s*child: const Text\(\s*'Cancel'", "Cancel closes the dialog without saving"),
    ("TC-DEV-01", "defect", "lib/views/screens/devices_screen.dart", r"childAspectRatio: 0\.85,\s*children: \[\s*\],", "All Devices grid has no children"),

    # ---- Switch / Smart plug / AC -----------------------------------------
    ("TC-SW-03", "defect", "lib/views/screens/switch_screen.dart", r"onChanged: \(value\) async \{\s*await widget\.entity\.toggle\(\);\s*\}",
     "Toggle has no try/catch, so a backend error shows no message"),
    ("TC-PLUG-01", "defect", "lib/views/screens/smart_plug_screen.dart", r"// await HomeAssistantService\.toggleDevice", "API call is commented out"),
    ("TC-PLUG-01", "defect", "lib/views/screens/smart_plug_screen.dart", r"Duration\(milliseconds: 50\)", "Message only shows for 50 ms"),
    ("TC-AC-01", "defect", "lib/views/screens/ac_slider_screen.dart", r"class AirConditionerControlScreen extends StatelessWidget",
     "Screen is stateless: slider changes are never redrawn"),
    ("TC-AC-01", "expect", "lib/views/screens/ac_slider_screen.dart", r"min: 16\.0,\s*max: 30\.0,", "Configured range 16-30"),
    ("TC-AC-02", "defect", "lib/views/screens/ac_slider_screen.dart", r"onChanged: \(value\) \{\s*_temperature = value;\s*\}", "Value changes without setState"),
    ("TC-AC-02", "expect", "lib/views/screens/ac_slider_screen.dart", r"divisions: 14", "Step of 1 degree (14 divisions)"),
    ("TC-AC-03", "defect", "lib/views/screens/ac_slider_screen.dart", r"onSelected: \(selected\) \{\s*_mode = mode;\s*\}", "Mode changes without setState: Cool stays highlighted"),
    ("TC-AC-04", "defect", "lib/views/screens/ac_slider_screen.dart", r"_fanSpeed = value\.toInt\(\);", "Fan speed changes without setState"),
    ("TC-AC-05", "defect", "lib/views/screens/ac_slider_screen.dart", r'_mode == "Off" \? "On" : "Off"', "Message always says Off"),
    ("TC-AC-05", "defect", "lib/views/screens/ac_slider_screen.dart", r"// Simulate turning the AC on/off", "No API call is made"),

    # ---- Servo ------------------------------------------------------------
    ("TC-SERVO-02", "expect", "lib/views/screens/servo_slider_screen.dart", r"onChangeEnd: _updateServoPosition", "Value sent on release only"),
    ("TC-SERVO-04", "expect", "lib/views/screens/servo_slider_screen.dart", r"'Failed to update servo: \$\{e\.toString\(\)\}'", "Error message on failure"),

    # ---- Automation rules -------------------------------------------------
    ("TC-RULE-01", "expect", "lib/views/screens/sensor_rule_screen.dart", r"contains\('temperature'\)\) return -10\.0", "Temperature min -10"),
    ("TC-RULE-01", "expect", "lib/views/screens/sensor_rule_screen.dart", r"contains\('temperature'\)\) return 50\.0", "Temperature max 50"),
    ("TC-RULE-01", "expect", "lib/views/screens/sensor_rule_screen.dart", r"contains\('temperature'\)\) return 60;", "60 divisions = step 1"),
    ("TC-RULE-02", "expect", "lib/views/screens/sensor_rule_screen.dart", r"contains\('smoke'\)\) return 45;", "Smoke (5000-500)/45 = step 100"),
    ("TC-RULE-02", "expect", "lib/views/screens/sensor_rule_screen.dart", r"contains\('light'\)\) return 120;", "Light (8000-2000)/120 = step 50"),
    ("TC-RULE-02", "expect", "lib/views/screens/sensor_rule_screen.dart", r"contains\('humidity'\)\) return 100;", "Humidity 0-100 = step 1"),
    ("TC-RULE-03", "defect", "lib/views/screens/sensor_rule_screen.dart", r"ruleValue = \(matchingRule\['threshold'\] as num\)\.toDouble\(\);",
     "(Extra finding) Saved threshold is loaded without setState after the slider was already set to the midpoint"),
    ("TC-RULE-06", "defect", "lib/views/screens/sensor_rule_screen.dart", r'debugPrint\("Failed to save rule', "Failed save only goes to the debug log"),

    # ---- Settings ---------------------------------------------------------
    ("TC-IP-01", "defect", "lib", r"showIpInputDialog\(context",
     "The IP dialog is never opened from any screen (only its definition exists)"),
    ("TC-IP-01", "defect", "lib/services/api_service.dart", r"static bool _useBackendServer = true;", "Backend mode ignores the saved 'home_assistant_ip'"),
    ("TC-IP-01", "defect", "lib", r"192\.168\.151\.76", "Backend IP is hard-coded"),
    ("TC-IP-02", "defect", "lib/views/widgets/show_popup_ipaddress.dart", r"await IpRepository\(\)\.setIp\(ipController\.text\);", "Any text is saved with no validation (and untrimmed)"),

    # ---- Code-only findings -----------------------------------------------
    ("SD-12", "defect", "lib", r'static const id = "smartplugcontrolscreen";', "Same route id used twice"),
    ("SD-13", "defect", "firestore.rules", r"allow read, write: if true;", "Firestore open to anyone"),
    ("DOC", "defect", "README.md", r"secrets\.example\.dart", "README refers to lib/configs/secrets.example.dart, which is not in the repo"),
    ("DOC", "defect", "README.md", r"screenshots/home\.png", "README shows screenshots/ images that are not in the repo"),
]

# These tests are Blocked in the workbook: the result needs the server or the hardware.
# Their checks are only notes about what the code shows, so they are reported as BLOCKED.
BLOCKED = {"TC-LOG-08", "TC-LOG-09", "TC-REG-01", "TC-SERVO-02"}

# For checks marked "lib", search every Dart file and skip definitions/route tables.
SKIP_FOR_USAGE = {
    "TC-ROOM-01": ["lib/main.dart", "lib/views/screens/rooms_screen.dart"],
    "TC-IP-01": ["lib/views/widgets/show_popup_ipaddress.dart"],
}

# Tests where the defect is "something is missing" (pattern = negative lookahead) or usage-based.
USAGE_CHECKS = {("TC-ROOM-01", r"RoomsPage\.id|RoomsPage\(\)"),
                ("TC-IP-01", r"showIpInputDialog\(context")}


def read(path):
    with open(os.path.join(ROOT, path), encoding="utf-8") as f:
        return f.read()


def dart_files():
    for d, _, files in os.walk(os.path.join(ROOT, "lib")):
        for n in files:
            if n.endswith(".dart"):
                yield os.path.relpath(os.path.join(d, n), ROOT)


def find(path, pattern):
    """Return list of (file, line) where pattern matches."""
    files = list(dart_files()) if path == "lib" else [path]
    hits = []
    for f in files:
        text = read(f)
        for m in re.finditer(pattern, text, re.MULTILINE):
            hits.append((f, text.count("\n", 0, m.start()) + 1))
            if pattern.startswith("\\A(?!"):
                break
    return hits


def run_check(tc, kind, path, pattern):
    if (tc, pattern) in USAGE_CHECKS:
        # Defect = there are NO usages outside the skipped files.
        hits = [h for h in find(path, pattern) if h[0] not in SKIP_FOR_USAGE.get(tc, [])]
        return (len(hits) == 0), hits
    hits = find(path, pattern)
    return bool(hits), hits


def main():
    try:
        commit = subprocess.check_output(["git", "-C", ROOT, "log", "-1", "--format=%h", "--", "lib"], text=True).strip()
    except Exception:
        commit = "unknown"
    print("HomeSync code checks")
    print(f"App code commit: {commit}   Date: {date.today().isoformat()}   Checks: {len(CHECKS)}")
    print("=" * 78)

    results = {}
    for tc, kind, path, pattern, meaning in CHECKS:
        found, hits = run_check(tc, kind, path, pattern)
        where = ", ".join(f"{f}:{l}" for f, l in hits[:3]) or "-"
        if (tc, pattern) in USAGE_CHECKS:
            where = "no usage found" if found else where
        elif pattern.startswith("\\A(?!") and found:
            where = f"not present anywhere in {path}"
        if kind == "expect":
            ok = found
            label = "OK     " if ok else "MISSING"
        else:
            ok = not found
            label = "DEFECT " if found else "clear  "
        extra = meaning.startswith("(Extra finding")
        if not extra:
            results.setdefault(tc, True)
            results[tc] = results[tc] and ok
        print(f"[{label}] {tc:<11} {meaning}\n            at {where}")

    print("=" * 78)
    print("Result per test case (code level only):")
    counts = {"PASS": 0, "FAIL": 0, "BLOCKED": 0}
    for tc, ok in results.items():
        verdict = "BLOCKED" if tc in BLOCKED else ("PASS" if ok else "FAIL")
        counts[verdict] += 1
        print(f"  {tc:<11} {verdict}")
    print(f"\n{len(results)} items checked, {counts['PASS']} pass, {counts['FAIL']} fail, {counts['BLOCKED']} blocked")


if __name__ == "__main__":
    sys.exit(main())
