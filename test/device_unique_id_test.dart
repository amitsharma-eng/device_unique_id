import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:device_unique_id/device_unique_id.dart';
import 'package:device_unique_id/src/device_unique_id_platform_interface.dart';

class MockDeviceUniqueIdPlatform
    with MockPlatformInterfaceMixin
    implements DeviceUniqueIdPlatform {
  String storedId = 'mock-uuid-1234';
  bool wasReset = false;

  @override
  Future<DeviceIdentity> getDeviceIdentity() async {
    return DeviceIdentity(
      persistentId: storedId,
      androidId: 'mock-android-id',
      identifierForVendor: null,
    );
  }

  @override
  Future<String> getPersistentId() async => storedId;

  @override
  Future<void> resetPersistentId() async {
    wasReset = true;
    storedId = 'mock-uuid-regenerated';
  }
}

void main() {
  late MockDeviceUniqueIdPlatform mockPlatform;

  setUp(() {
    mockPlatform = MockDeviceUniqueIdPlatform();
    DeviceUniqueIdPlatform.instance = mockPlatform;
  });

  test('getPersistentId returns the platform-provided id', () async {
    expect(await DeviceUniqueId.getPersistentId(), 'mock-uuid-1234');
  });

  test('getDeviceIdentity surfaces platform-specific fields', () async {
    final identity = await DeviceUniqueId.getDeviceIdentity();
    expect(identity.persistentId, 'mock-uuid-1234');
    expect(identity.androidId, 'mock-android-id');
    expect(identity.identifierForVendor, isNull);
  });

  test('resetPersistentId delegates to the platform and id changes', () async {
    await DeviceUniqueId.resetPersistentId();
    expect(mockPlatform.wasReset, isTrue);
    expect(await DeviceUniqueId.getPersistentId(), 'mock-uuid-regenerated');
  });
}
