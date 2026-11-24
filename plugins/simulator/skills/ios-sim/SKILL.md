---
name: ios-sim
description: Build, install and drive an iOS app in the Simulator: launch it, look at the screen, tap, type, read logs. Use when asked to run, test, debug or check an iOS app's UI.
---
Tools: `sim.devices`, `sim.boot`, `sim.install`, `sim.launch`, `sim.screenshot`, `sim.ui`, `sim.tap`, `sim.swipe`, `sim.type`, `sim.key`, `sim.openurl`, `sim.logs`, `sim.terminate`. Taps, typing and `sim.ui` need `idb` (`brew install facebook/fb/idb-companion && pipx install fb-idb`).

1. `sim.devices`; `sim.boot` an iPhone if none is booted. With one device booted, `device` can be left out.
2. Build for it: `xcodebuild -scheme <scheme> -destination 'id=<udid>' -derivedDataPath .build/sim build` (add `-workspace` or `-project`). The app is `.build/sim/Build/Products/Debug-iphonesimulator/<Name>.app`.
3. `sim.install` that `.app`, then `sim.launch` with its bundle id (`defaults read <app>/Info CFBundleIdentifier`).
4. Look: `sim.screenshot`, or `sim.ui` for the labels and frames (cheaper). Act with `sim.tap label="…"`; use x, y only when nothing has a label. x and y are pixels of the screenshot image, not points.
5. Check the result with `sim.tap … screenshot=true` or another `sim.screenshot`.
6. On a crash or a wrong screen: `sim.logs app=<process or bundle id> seconds=60`.

Keep screenshots few: each costs about 1.6k tokens. Prefer `sim.ui` to find things, and a screenshot to confirm. A system dialog (permissions) hides the app's elements: tap its button first.
