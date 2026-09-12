Pod::Spec.new do |s|
  s.name             = 'device_unique_id'
  s.version          = '1.0.0'
  s.summary          = 'Reliable device identifiers (Android ID, IDFV, persistent UUID) for Android and iOS.'
  s.description      = <<-DESC
Get a reliable device identifier on Android and iOS via ANDROID_ID,
identifierForVendor, and a Keychain-backed persistent UUID.
                       DESC
  s.homepage         = 'https://github.com/amitsharma-eng/device_unique_id'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Amit Sharma' => 'amitsharma-eng@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version    = '5.0'
end
