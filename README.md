# device_unique_id

A reliable device identifier for Android and iOS — using the modern,
privacy-respecting approach both platforms actually allow.

## Read this first: what's *not* possible

Neither OS lets a normal app read a true hardware serial number or IMEI.
This is an intentional privacy restriction, not a gap in this package:

- **Android 8+**: `Build.getSerial()` requires the `READ_PRIVILEGED_PHONE_STATE`
  permission, which only system/OEM-signed apps can hold. Regular apps
  get back `"UNKNOWN"`.
- **iOS**: Apple removed third-party UDID access in iOS 5 (2011) and has
  never brought it back. Attempting to work around it is an automatic
  App Store rejection.

If someone tells you their package returns the "real" hardware serial on
a normal, non-MDM app — be skeptical of it.

## What this package gives you instead

| Method | Android | iOS | Survives reinstall? |
|---|---|---|---|
| `getPersistentId()` | EncryptedSharedPreferences UUID | Keychain UUID | ✅ on iOS, ❌ on Android (removed with app data unless backed up) |
| `getDeviceIdentity().androidId` | `Settings.Secure.ANDROID_ID` | `null` | ❌ (resets on factory reset) |
| `getDeviceIdentity().identifierForVendor` | `null` | `UIDevice.identifierForVendor` | ❌ (resets if all vendor's apps are deleted) |

**Use `getPersistentId()` for most purposes** — licensing checks, fraud
signals, per-device analytics. It's the most stable option across both
platforms and isn't tied to an OS identifier policy that could change in
a future release.

## Setup

No manual native setup needed beyond normal Flutter plugin registration
— just add the dependency and you're done.

```yaml
dependencies:
  device_unique_id: ^1.0.0
```

**Android minSdk**: 21 (uses AndroidX Security Crypto for encrypted storage).
**iOS deployment target**: 12.0.

## Usage

```dart
import 'package:device_unique_id/device_unique_id.dart';

// Recommended: the persistent, package-managed UUID.
final id = await DeviceUniqueId.getPersistentId();

// Or get everything this plugin can retrieve:
final identity = await DeviceUniqueId.getDeviceIdentity();
print(identity.persistentId);         // always present
print(identity.androidId);            // null on iOS
print(identity.identifierForVendor);  // null on Android

// Mainly for testing "fresh install" behavior:
await DeviceUniqueId.resetPersistentId();
```

## Choosing the right id for your use case

- **Software licensing / seat limits** → `getPersistentId()`. Stable,
  under your control, works the same way on both platforms.
- **Fraud/abuse signals** → combine `getPersistentId()` with your
  server-side account/session data; no client-side id alone is a
  reliable fraud signal, since a determined user can always reinstall
  or clear storage.
- **Simple per-install analytics** → `getPersistentId()` is fine, or use
  a random id generated and stored entirely in your own app if you don't
  want the native dependency at all.

## Project structure

```
device_unique_id/
├── lib/
│   ├── device_unique_id.dart              # public API
│   └── src/
│       ├── device_identity.dart           # DeviceIdentity model
│       ├── device_unique_id_platform_interface.dart
│       └── method_channel_device_unique_id.dart
├── android/
│   └── src/main/kotlin/.../DeviceUniqueIdPlugin.kt
├── ios/
│   └── Classes/DeviceUniqueIdPlugin.swift
├── example/
│   └── main.dart
└── test/
    └── device_unique_id_test.dart
```

## Contributing

Issues and PRs welcome. Native code changes should be tested on a real
device where possible — the Keychain/EncryptedSharedPreferences behavior
in particular doesn't fully reflect on simulators/emulators in all cases.
