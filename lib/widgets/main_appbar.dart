import 'package:flutter/material.dart';

AppBar MainAppBar({required String text, required BuildContext context}) {
  return AppBar(
    title: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
}
