package com.amitsharma.device_unique_id

import android.content.Context
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.UUID

/** DeviceUniqueIdPlugin */
class DeviceUniqueIdPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var appContext: Context

  companion object {
    private const val PREFS_FILE = "device_unique_id_prefs"
    private const val KEY_PERSISTENT_ID = "persistent_id"
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_unique_id")
    channel.setMethodCallHandler(this)
    appContext = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getDeviceIdentity" -> {
        val map = HashMap<String, String?>()
        map["persistentId"] = getOrCreatePersistentId()
        map["androidId"] = getAndroidId()
        map["identifierForVendor"] = null // iOS-only concept
        result.success(map)
      }
      "getPersistentId" -> result.success(getOrCreatePersistentId())
      "resetPersistentId" -> {
        encryptedPrefs().edit().remove(KEY_PERSISTENT_ID).apply()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private fun getAndroidId(): String? {
    return try {
      Settings.Secure.getString(appContext.contentResolver, Settings.Secure.ANDROID_ID)
    } catch (e: Exception) {
      null
    }
  }

  /**
   * Returns the existing persistent UUID, or generates and stores a new
   * one on first call. Backed by EncryptedSharedPreferences (AES-256),
   * which is the modern replacement for plain SharedPreferences when
   * storing anything identity-like.
   *
   * Note: unlike iOS Keychain, this data is removed if the user
   * uninstalls the app (unless the app's data is included in an Android
   * backup that gets restored to the same device). If you need an id
   * that's resilient to reinstall on Android too, pair this with a
   * server-side account/login instead.
   */
  private fun getOrCreatePersistentId(): String {
    val prefs = encryptedPrefs()
    val existing = prefs.getString(KEY_PERSISTENT_ID, null)
    if (existing != null) return existing

    val newId = UUID.randomUUID().toString()
    prefs.edit().putString(KEY_PERSISTENT_ID, newId).apply()
    return newId
  }

  private fun encryptedPrefs() = run {
    val masterKey = MasterKey.Builder(appContext)
      .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
      .build()

    EncryptedSharedPreferences.create(
      appContext,
      PREFS_FILE,
      masterKey,
      EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
      EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
    )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
