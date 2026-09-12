import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'device_identity.dart';
import 'device_unique_id_platform_interface.dart';

class MethodChannelDeviceUniqueId extends DeviceUniqueIdPlatform {
  @visibleForTesting
  final MethodChannel channel = const MethodChannel('device_unique_id');

  @override
  Future<DeviceIdentity> getDeviceIdentity() async {
    final result = await channel.invokeMapMethod<String, dynamic>('getDeviceIdentity');
    final map = result ?? const <String, dynamic>{};
    return DeviceIdentity(
      persistentId: map['persistentId'] as String? ?? '',
      androidId: map['androidId'] as String?,
      identifierForVendor: map['identifierForVendor'] as String?,
    );
  }

  @override
  Future<String> getPersistentId() async {
    final id = await channel.invokeMethod<String>('getPersistentId');
    return id ?? '';
  }

  @override
  Future<void> resetPersistentId() async {
    await channel.invokeMethod<void>('resetPersistentId');
  }
}
