import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:login_page/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String message;
  LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('LoadingDialog'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circultarProgress(),
          const SizedBox(
            height: 10,
          ),
          Text(message + ", Authenticating, please wait..."),
        ],
      ),
    );
  }
}
