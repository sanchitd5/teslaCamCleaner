import 'package:flutter/material.dart';

class DevEnvironmentListTile extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  DevEnvironmentListTile({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: ElevatedButton(
        child: Text(title, style: TextStyle(color: Colors.black)),
        onPressed: onPressed,
      ),
    );
  }
}
