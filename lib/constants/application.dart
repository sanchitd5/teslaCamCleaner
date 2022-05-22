import 'package:package_info_plus/package_info_plus.dart';

class ApplicationConstants {
  String _title = '';
  String _version = '';
  final String author = 'Sanchit Dang';
  final String copyright = "Sanchit Dang 2020 - ${DateTime.now().year}";
  ApplicationConstants() {
    PackageInfo.fromPlatform().then((packageInfo) {
      _title = packageInfo.appName;
      _version = "${packageInfo.version}_${packageInfo.buildNumber}";
    });
  }

  String get title => _title;
  String get version => _version;
}
