import 'package:flutter/material.dart';

void showSignInAlertDialog({
  required BuildContext context,
  required String errorMessage,
}) {
  showDialog(
    context: context,
    builder: ((ctx) => AlertDialog(
          title: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            )
          ],
        )),
  );
}
