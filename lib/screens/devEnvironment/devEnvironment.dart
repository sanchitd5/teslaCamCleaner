import 'package:flutter/material.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class DevEnvironment extends StatelessWidget {
  static const String route = '/dev';

  const DevEnvironment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Tools'),
      ),
      body: ListView(
        children: [
          DevEnvironmentListTile(
            title: 'Logout',
            onPressed: () {
              Provider.of<UserStateProvider>(context, listen: false)
                  .logout(context);
            },
          ),
        ],
      ),
    );
  }
}
