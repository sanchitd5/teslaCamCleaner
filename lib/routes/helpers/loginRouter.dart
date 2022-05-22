import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../providers/providers.dart';
import '../../screens/screens.dart';
import '../../widgets/widgets.dart';

class LoginRouter extends StatefulWidget {
  const LoginRouter({Key? key}) : super(key: key);

  @override
  LoginRouterState createState() => LoginRouterState();
}

class LoginRouterState extends State<LoginRouter> {
  @override
  void initState() {
    // perform an accessTokenLogin when application resumes
    Provider.of<UserStateProvider>(context, listen: false)
        .accessTokenLogin()
        .then((value) {
      // if success get user profile
      if (value) {
        Provider.of<UserProfileProvider>(context, listen: false)
            .getUserProfile();
      }
    });
    super.initState();
  }

  Widget _landingScreen() {
    if (Constants.devConsole != false) return const DevEnvironment();
    return const Home();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStateProvider>(
      builder: (context, userData, widget) {
        // navigate to welcome screen if user not logged in.
        if (userData.loginStatus == false) return WelcomePage();
        // navigate to home screen if backend bypassed
        if (Constants.bypassBackend) return _landingScreen();
        return Consumer<UserProfileProvider>(
          builder: (context, userData, widget) {
            // displayt loading screeen until the profile is loaded
            if (userData.userProfile == null) return LoadingScreen();
            // navigate to change password screen if firstlogin is not performed
            if (userData.userProfile!.firstLogin == false) {
              return const ChangePassword();
            }
            // when all conditions pass navigate to the home screen
            return _landingScreen();
          },
        );
      },
    );
  }
}
