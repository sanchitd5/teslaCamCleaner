import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import "../../helpers/helpers.dart";
import '../../models/models.dart';

class DioInstance {
  final Dio _instance = Dio();
  final String _baseUrl =
      '${Constants.connectionConstants.baseUrl}/api/';
  final int _connectionTimeout = 5000;
  final int _receiveTimeout = 3000;

  DioInstance() {
    if (Constants.devBuild == true) {
      _instance.interceptors.add(LogInterceptor(responseBody: true));
    }
    // assign base url for the application
    _instance.options.baseUrl = _baseUrl;
    _instance.options.connectTimeout = _connectionTimeout;
    _instance.options.receiveTimeout = _receiveTimeout;
    logger.i('DIO instance Constructed\nBase Url: $_baseUrl');
  }

  Dio get instance {
    return _instance;
  }

  DIOResponseBody errorHelper(dynamic onError) {
    if (onError == null) {
      return DIOResponseBody(success: false, data: 'Network Error');
    }
    if (onError['response'] == null) {
      return DIOResponseBody(
          success: false, data: 'Connection to Backend Failed');
    }
    if (onError?['response']?['data']?['message'] != null) {
      return DIOResponseBody(
          success: false, data: onError['response']['data']['message']);
    }
    return DIOResponseBody(success: false, data: "Oops! Something went wrong!");
  }

  Future<String> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('accessToken')) return '';
    var token = prefs.getString('accessToken');
    return token ?? '';
  }
}
