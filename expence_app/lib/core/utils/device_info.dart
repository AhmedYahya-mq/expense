import 'package:flutter/services.dart' show MethodChannel;

class DeviceInfo {
  static const MethodChannel _channel = MethodChannel('device_info');

  static Future<int> getAndroidVersion() async {
    try {
      final String version = await _channel.invokeMethod('getAndroidVersion');
      return int.parse(version);
    } catch (e) {
      return 0;
    }
  }
}
