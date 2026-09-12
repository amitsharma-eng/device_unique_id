import Flutter
import UIKit
import Security

public class DeviceUniqueIdPlugin: NSObject, FlutterPlugin {
  private static let service = "com.amitsharma.device_unique_id"
  private static let account = "persistent_id"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_unique_id", binaryMessenger: registrar.messenger())
    let instance = DeviceUniqueIdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDeviceIdentity":
      var map: [String: String?] = [:]
      map["persistentId"] = getOrCreatePersistentId()
      map["androidId"] = nil // Android-only concept
      map["identifierForVendor"] = UIDevice.current.identifierForVendor?.uuidString
      result(map)
    case "getPersistentId":
      result(getOrCreatePersistentId())
    case "resetPersistentId":
      deleteFromKeychain()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Returns the existing persistent UUID from the Keychain, or
  /// generates and stores a new one on first call. Keychain items
  /// survive app uninstall/reinstall on the same device by default,
  /// which is what makes this more durable than identifierForVendor
  /// alone in the "user reinstalls the app" case.
  private func getOrCreatePersistentId() -> String {
    if let existing = readFromKeychain() {
      return existing
    }
    let newId = UUID().uuidString
    saveToKeychain(newId)
    return newId
  }

  private func readFromKeychain() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Self.service,
      kSecAttrAccount as String: Self.account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data else { return nil }
    return String(data: data, encoding: .utf8)
  }

  private func saveToKeychain(_ value: String) {
    let data = value.data(using: .utf8)!
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Self.service,
      kSecAttrAccount as String: Self.account
    ]
    // Remove any existing item first so this also works for updates.
    SecItemDelete(query as CFDictionary)

    var newItem = query
    newItem[kSecValueData as String] = data
    newItem[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
    SecItemAdd(newItem as CFDictionary, nil)
  }

  private func deleteFromKeychain() {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Self.service,
      kSecAttrAccount as String: Self.account
    ]
    SecItemDelete(query as CFDictionary)
  }
}
