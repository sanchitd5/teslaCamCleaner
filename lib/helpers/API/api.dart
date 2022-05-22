import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../models/models.dart';
import './dioInstance.dart';

class API {
  static final API api = API._privateConstructor();
  final DioInstance _dioInstance = DioInstance();

  API._privateConstructor() {
    if (kDebugMode) {
      print("All APIs initialized.");
    }
  }

  factory API() {
    return api;
  }

  Future<DIOResponseBody> userLogin(LoginAPIBody details) async {
    return _dioInstance.instance
        .post('user/login', data: await details.toLoginApiJSON)
        .then((respone) {
      return DIOResponseBody(success: true, data: respone.data['data']);
    }).catchError((error) {
      return _dioInstance.errorHelper(error);
    });
  }

  Future<DIOResponseBody> accessTokenLogin(String accessToken) async {
    return _dioInstance.instance
        .post('user/accessTokenLogin',
            options: Options(headers: {'authorization': 'Bearer $accessToken'}))
        .then((response) {
      return DIOResponseBody(success: true, data: response.data['data']);
    }).catchError((error) {
      return _dioInstance.errorHelper(error);
    });
  }

  Future<DIOResponseBody> registerUser(userDetails) async {
    return _dioInstance.instance
        .post('user/register', data: userDetails)
        .then((respone) => DIOResponseBody(success: true))
        .catchError((error) => _dioInstance.errorHelper(error));
  }

  Future<bool> logout(String token) {
    return _dioInstance.instance
        .put(
          'user/logout',
          options: Options(headers: {'authorization': 'Bearer $token'}),
        )
        .then((value) => true)
        .catchError((err) => false);
  }

  Future<DIOResponseBody> changePassword(ChangePasswordAPIBody data) async {
    return _dioInstance.instance
        .put(
          'user/changePassword',
          data: data.toJSON(),
          options: Options(
            headers: {
              'authorization': 'Bearer ${await _dioInstance.accessToken}'
            },
          ),
        )
        .then((response) => DIOResponseBody(
              success: true,
              data: response.data['data'],
            ))
        .catchError((onError) => _dioInstance.errorHelper(onError));
  }

  Future<DIOResponseBody> getProfile() async {
    return _dioInstance.instance
        .get(
          'user/getProfile',
          options: Options(
            headers: {
              'authorization': 'Bearer ${await _dioInstance.accessToken}'
            },
          ),
        )
        .then((response) => DIOResponseBody(
            success: true, data: response.data['data']['customerData']))
        .catchError((onError) => _dioInstance.errorHelper(onError));
  }
}
