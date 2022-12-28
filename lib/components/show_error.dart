import 'package:flutter/material.dart';

Future<void> showmessage(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
