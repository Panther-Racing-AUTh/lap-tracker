import 'package:flutter/material.dart';

ElevatedButton oAuthButton(
    {required Future<void> Function() function,
    required IconData icon,
    required String text}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      elevation: 5,
      minimumSize: Size(double.infinity, 50),
    ),
    icon: Icon(icon),
    label: Text(text),
    onPressed: () => function(),
  );
}
