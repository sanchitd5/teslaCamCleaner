import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            CircularProgressIndicator.adaptive(),
            SizedBox(
              height: 20,
            ),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
