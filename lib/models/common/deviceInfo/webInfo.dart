import 'package:device_info_plus/device_info_plus.dart';

class WebInfo {
  final DeviceInfoPlugin _infoplugin = DeviceInfoPlugin();
  String uuid;

  WebInfo({required this.uuid});

  Future<Map<String, String>> get info async {
    WebBrowserInfo info = await _infoplugin.webBrowserInfo;

    return {
      'deviceUUID': uuid,
      'deviceType': 'WEB',
      'deviceName':
          '${info.browserName.toString().split(".").last} on ${info.platform}',
    };
  }
}
