// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_onboarding/models/models.dart';
import '../helpers/loginRouter.dart';
import '../helpers/parentRouter.dart';
import '../../constants/constants.dart';
import '../../screens/screens.dart';

class EC2Router extends ParentRouter {
  final BuildContext appContext;

  @override
  RouteConfig defaultRoute = Constants.useAuth
      ? RouteConfig(
          route: '/',
          widget: const LoginRouter(),
          type: RouteType.UN_AUTHENTICATED)
      : RouteConfig(
          route: '/', widget: const Home(), type: RouteType.UN_AUTHENTICATED);

  EC2Router(this.appContext);

  Future<String> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('accessToken')) return '';
    var token = prefs.getString('accessToken');
    return token ?? '';
  }

  // @override
  // Widget authWidget(Widget screen) {
  //   return FutureBuilder(
  //     future: accessToken,
  //     builder: (context, tokenSnapshot) {
  //       if (tokenSnapshot.connectionState == ConnectionState.waiting) {
  //         return LoadingScreen();
  //       }
  //       if (tokenSnapshot.data == '') return WelcomePage();
  //       return screen;
  //     },
  //   );
  // }

}
