# Changelog

## 1.0.0

- Initial release.
- `DeviceUniqueId.getPersistentId()` — Keychain (iOS) / EncryptedSharedPreferences
  (Android) backed UUID, generated once on first launch.
- `DeviceUniqueId.getDeviceIdentity()` — the above plus the raw platform
  id (`ANDROID_ID` on Android, `identifierForVendor` on iOS).
- `DeviceUniqueId.resetPersistentId()` — clears the stored UUID (mainly
  for testing "new install" flows).
- Standard platform-interface architecture so this can later split into
  federated platform packages without a breaking change.
