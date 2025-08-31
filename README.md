# Jiggle native module (iOS + Android)

This package provides a small native module that exposes device vibration/haptic functionality to the Lynx runtime. The implementation includes both Android and iOS code.

## Summary
- API: vibrate(durationMs) — vibrates the device for the provided duration in milliseconds.
- Android implementation: `packages/jiggle/android/src/main/kotlin/.../JiggleModule.kt` (uses Vibrator/VibratorManager).
- iOS implementation: `packages/jiggle/ios/jiggle/Classes/JiggleModule.swift` (uses CoreHaptics with AudioToolbox fallback).

## Layout
- `packages/jiggle/android/` — full Android module (Gradle config + Kotlin source). The main class is `JiggleModule.kt`.
- `packages/jiggle/ios/jiggle.podspec` — CocoaPods podspec reading `package.json` for metadata.
- `packages/jiggle/ios/jiggle/Classes/` — Swift source and public headers for the iOS pod.

## API details
- vibrate(durationMs)
  - Parameter: durationMs (number) — duration to vibrate in milliseconds.
  - Android: implemented as `fun vibrate(duration: Long)` in `JiggleModule.kt`.
  - iOS: implemented as `- (void)vibrate:(NSNumber *)duration` in the Objective-C header and `@objc public func vibrate(_ duration: NSNumber)` in Swift. The iOS side uses CoreHaptics (if available) and falls back to `AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)`.

## Development / verification
- To validate the iOS podspec (macOS with CocoaPods installed):

  pod lib lint packages/jiggle/ios/jiggle.podspec

- To build/run Android code, use the usual Gradle tooling from `packages/jiggle/android`.

## Notes
- The podspec expects `version`, `license`, `description`, and `author` fields to exist in `packages/jiggle/package.json` — they were added/updated in this repo.
- The iOS Swift class is instance-based; ensure the module is created and registered by your Lynx bridge similarly to the Android registration.

If you want I can:
- Run a `pod lib lint` here and fix any lint issues.
- Change the iOS API to a static method if you prefer.

## Using with tamer4lynx

To include this native module in a Lynx app managed by `tamer4lynx`, follow these steps:

1. Ensure the module lives in your workspace under `packages/jiggle`.
2. Add a `tamer.json` (or update it) at the root of the module to let the CLI know how to link it. Example:

```json
{
  "android": {
    "moduleClassName": "com.nanofuxion.vibration.JiggleModule",
    "sourceDir": "android"
  },
  "ios": {
    "podspec": "ios/jiggle.podspec",
    "sourceDir": "ios"
  }
}
```

3. From the repository root run the linker (choose platform flags as needed):

```
t4l link --both
```

This will add the Android module registration and install the iOS podspec into the host projects so the native code is available to your Lynx app.

4. Call the native API from your Lynx JavaScript code. How native modules are exposed depends on your app bridge; a generic example (pseudo-code):

```js
// Pseudo-code — adapt to your project's native bridge
if (global.nativeModules && global.nativeModules.Jiggle) {
  // vibrate for 200ms
  global.nativeModules.Jiggle.vibrate(200);
}
```

If you want, I can add a small JS wrapper in `packages/jiggle` to expose a stable JS API for the module and demonstrate calling it from the `packages/example` project.
iOS Pod for `jiggle`

This directory contains the CocoaPods specification and minimal source for the `jiggle` native module. It mirrors the structure used by the `lynxwebsockets` package in this mono-repo.

Files:
- `jiggle.podspec` - Podspec that reads package.json for metadata
- `jiggle/Classes/` - Swift source, bridging header and public headers

Usage:
Run `pod lib lint` inside this folder to verify the podspec.
