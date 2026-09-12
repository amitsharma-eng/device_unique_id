/// The set of identifiers this plugin can retrieve. Not every field is
/// available on every platform — see the doc comment on each field.
class DeviceIdentity {
  const DeviceIdentity({
    required this.persistentId,
    this.androidId,
    this.identifierForVendor,
  });

  /// A UUID generated on first launch and stored in the Keychain (iOS) or
  /// EncryptedSharedPreferences (Android). This is the recommended id to
  /// use for most purposes — it's the most stable across OS policy
  /// changes and, on iOS, survives app uninstall/reinstall because
  /// Keychain data outlives the app itself.
  final String persistentId;

  /// `Settings.Secure.ANDROID_ID` — Android only. Unique per
  /// device + app-signing-key combination. Null on iOS, and can be null
  /// on Android in rare OEM-specific edge cases.
  final String? androidId;

  /// `UIDevice.identifierForVendor` — iOS only. Unique per device per
  /// vendor (apps published by the same team share it). Null on Android.
  /// Can change if the user deletes every app from this vendor and later
  /// reinstalls one.
  final String? identifierForVendor;

  Map<String, String?> toMap() => {
        'persistentId': persistentId,
        'androidId': androidId,
        'identifierForVendor': identifierForVendor,
      };

  @override
  String toString() => 'DeviceIdentity(${toMap()})';
}
