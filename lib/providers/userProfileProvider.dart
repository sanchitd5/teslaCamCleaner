import 'package:flutter/material.dart';
import '../models/models.dart';
import '../helpers/helpers.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfileAPIBody? _userProfile;

  UserProfileAPIBody? get userProfile => _userProfile;

  Future<UserProfileAPIBody?> getUserProfile() async {
    DIOResponseBody response = await API().getProfile();
    if (response.success) {
      _userProfile = UserProfileAPIBody.fromJson(response.data);
    }
    notifyListeners();
    return _userProfile;
  }
}
