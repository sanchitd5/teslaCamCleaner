import '../models/models.dart';
import 'application.dart';
import 'connection.dart';

class Constants {
  static ApplicationConstants applicationConstants = ApplicationConstants();
  static ConnectionConstants connectionConstants = ConnectionConstants();
  static const bool useAuth = false;
  static const bool devBuild = true;
  static const bool devConsole = true;
  static const bool debugBanner = false;
  static const bool bypassBackend = true;
  static const String devAccessToken = 'dummyToken';
  static final LoginAPIBody devUser = LoginAPIBody(
    username: 'user@sanchitdang.com',
    password: 'password',
  );
}
