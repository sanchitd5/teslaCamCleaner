import 'package:device_info_plus/device_info_plus.dart';

class AndroidInfo {
  final DeviceInfoPlugin _plugin = DeviceInfoPlugin();
  String uuid;
  AndroidInfo({required this.uuid});
  Future<Map<String, String>> get info async {
    AndroidDeviceInfo androidInfo = await _plugin.androidInfo;
    return {
      'deviceName':
          '${androidInfo.manufacturer} ${androidInfo.model} on Android ${androidInfo.version.release}',
      'deviceUUID': uuid,
      'deviceType': 'ANDROID'
    };
  }
}
