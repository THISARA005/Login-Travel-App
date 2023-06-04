import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  ErrorDialog({required this.message, required String title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('errorDialog'),
      content: Text(message),
      actions: [
        ElevatedButton(
            child: Center(child: Text('OK')),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
