---
name: android-emu
description: Build, install and drive an Android app in the emulator: launch it, look at the screen, tap, type, read logcat. Use when asked to run, test, debug or check an Android app's UI.
---
Tools: `sim.devices`, `sim.boot`, `sim.install`, `sim.launch`, `sim.screenshot`, `sim.ui`, `sim.tap`, `sim.swipe`, `sim.type`, `sim.key`, `sim.openurl`, `sim.logs`, `sim.terminate`. They need `adb` (on the PATH, or in `$ANDROID_HOME/platform-tools`) and, to boot, the `emulator`.

1. `sim.devices`: a running device is `android:<serial>`, a stopped AVD `android:avd:<name>`. `sim.boot` the AVD, then `sim.devices` again until it is booted (about a minute).
2. Build: `./gradlew assembleDebug`; the APK is in `app/build/outputs/apk/debug/`.
3. `sim.install` the APK (it replaces the app), then `sim.launch` with the package (`com.example.app`), or `package/.MainActivity` to start an activity.
4. Look: `sim.screenshot`, or `sim.ui` for the labels and frames (cheaper). Act with `sim.tap label="…"`; use x, y only when nothing has a label. x and y are pixels of the screenshot image.
5. `sim.type` is printable ASCII only and goes into the focused field; `sim.key` takes back, home, enter, backspace, recents…
6. On a crash: `sim.logs app=<package> seconds=60` (the app must be running; without `app` the whole logcat tail).

Keep screenshots few: each costs about 1.6k tokens. Prefer `sim.ui` to find things, and a screenshot to confirm.
