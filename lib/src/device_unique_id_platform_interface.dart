import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'device_identity.dart';
import 'method_channel_device_unique_id.dart';

/// The interface platform implementations of `device_unique_id` must
/// implement. Kept as a platform interface (rather than baking the
/// method channel directly into the public API) so this package can
/// later be split into federated platform packages without a breaking
/// change for consumers.
abstract class DeviceUniqueIdPlatform extends PlatformInterface {
  DeviceUniqueIdPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceUniqueIdPlatform _instance = MethodChannelDeviceUniqueId();

  /// The active platform implementation.
  static DeviceUniqueIdPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceUniqueIdPlatform] when
  /// they register themselves.
  static set instance(DeviceUniqueIdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<DeviceIdentity> getDeviceIdentity() {
    throw UnimplementedError('getDeviceIdentity() has not been implemented.');
  }

  Future<String> getPersistentId() {
    throw UnimplementedError('getPersistentId() has not been implemented.');
  }

  /// Deletes the stored persistent UUID so a new one is generated next
  /// time it's requested. Mainly useful for testing "new install" flows.
  Future<void> resetPersistentId() {
    throw UnimplementedError('resetPersistentId() has not been implemented.');
  }
}
