import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_onboarding/constants/constants.dart';
import '../models/models.dart';
import '../helpers/helpers.dart';

class UserStateProvider with ChangeNotifier {
  String? _accessToken;
  bool _userLoggedIn = false;
  bool? _firstSignIn;

  Future<bool> accessTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('accessToken')) return false;
    var localToken = prefs.getString('accessToken')!;
    DIOResponseBody response = await API().accessTokenLogin(localToken);
    if (response.success) {
      _userLoggedIn = true;
      _accessToken = localToken;
      _firstSignIn = !response.data?['userDetails']?['firstLogin'] || false;
      return true;
    } else {
      _userLoggedIn = false;
      _accessToken = "";
      return false;
    }
  }

  void performLogout(BuildContext context) async {
    _userLoggedIn = false;
    notifyListeners();
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  String? get accessToken => _accessToken;

  bool get loginStatus => _userLoggedIn;

  bool? get firstSignIn => _firstSignIn;

  void assignAccessToken(String token) async {
    if (token != "") {
      _accessToken = token;
      _userLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', token);
      prefs.setBool('loginStatus', true);
      notifyListeners();
    }
  }

  void changeFirstLoginStatus(bool status) async {
    _firstSignIn = status;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstSignIn', status);
    notifyListeners();
  }

  void logout(BuildContext context) async {
    bool response = Constants.bypassBackend || _accessToken == null
        ? true
        : await API().logout(_accessToken!);
    if (response) {
      performLogout(context);
    }
  }

  void changeLoginStatus(bool status) {
    _userLoggedIn = status;
    notifyListeners();
  }
}
