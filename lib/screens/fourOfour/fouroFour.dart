import 'dart:async';

import 'package:flutter/material.dart';

class Four0Four extends StatefulWidget {
  final Duration? redirectionDuration;
  final bool isInitialLoading;
  const Four0Four({
    Key? key,
    this.redirectionDuration,
    this.isInitialLoading = false,
  }) : super(key: key);
  @override
  State<Four0Four> createState() => _Four0FourState();
}

class _Four0FourState extends State<Four0Four> {
  late int _timer;

  @override
  void initState() {
    super.initState();
    Duration redTime = widget.redirectionDuration ?? const Duration(seconds: 3);
    _timer = redTime.inSeconds;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _timer--;
      });
      if (_timer == 0) {
        timer.cancel();
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInitialLoading) {
      return const Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '404 : Page not found',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Redirecting to default page in $_timer seconds',
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
