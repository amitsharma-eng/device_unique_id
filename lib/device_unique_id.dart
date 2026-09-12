import 'src/device_identity.dart';
import 'src/device_unique_id_platform_interface.dart';

export 'src/device_identity.dart';

/// Get a reliable device identifier on Android and iOS.
///
/// Neither OS lets regular apps read a true hardware serial/IMEI —
/// that's an intentional privacy restriction, not a limitation of this
/// package. What this package gives you instead is the modern,
/// privacy-respecting equivalent:
///
/// - [DeviceUniqueId.getPersistentId] — a UUID generated on first launch
///   and stored in the Keychain (iOS) / EncryptedSharedPreferences
///   (Android). **Use this for most purposes.**
/// - [DeviceUniqueId.getDeviceIdentity] — the above, plus the raw
///   platform-native id (`ANDROID_ID` or `identifierForVendor`) in case
///   you need it for a specific integration.
class DeviceUniqueId {
  DeviceUniqueId._();

  /// Returns the persistent, package-managed UUID. This is the
  /// recommended id for licensing, fraud checks, or per-device
  /// analytics, since it's the most stable across OS versions and,
  /// on iOS, survives app uninstall/reinstall.
  static Future<String> getPersistentId() {
    return DeviceUniqueIdPlatform.instance.getPersistentId();
  }

  /// Returns every identifier this plugin can retrieve, wrapped in a
  /// [DeviceIdentity]. Platform-specific fields are null on the other
  /// platform (e.g. [DeviceIdentity.androidId] is null on iOS).
  static Future<DeviceIdentity> getDeviceIdentity() {
    return DeviceUniqueIdPlatform.instance.getDeviceIdentity();
  }

  /// Clears the stored persistent UUID so a fresh one is generated on
  /// the next call to [getPersistentId] / [getDeviceIdentity]. Mainly
  /// useful in tests that need to simulate a "new install".
  static Future<void> resetPersistentId() {
    return DeviceUniqueIdPlatform.instance.resetPersistentId();
  }
}
