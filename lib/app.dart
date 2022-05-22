import 'package:flutter/material.dart';

import 'constants/constants.dart';
import 'providers/providers.dart';
import 'routes/routes.dart';
import 'theme/theme.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late EC2Router routerInstance;
  bool routerInitialized = false;

  @override
  void initState() {
    super.initState();
    routerInstance = EC2Router(context);
    routerInstance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Global Providers used by the application
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProfileProvider(),
        ),
      ],
      child: MaterialApp.router(
        // controls the debug banner for the application
        debugShowCheckedModeBanner: Constants.debugBanner,
        title:
            Constants.applicationConstants.title, // title for the application
        theme: ApplicationTheme(context).getAppTheme, // application theme
        routeInformationParser: routerInstance.router.routeInformationParser,
        routerDelegate:
            routerInstance.router.routerDelegate, // application screen routes
      ),
    );
  }
}
