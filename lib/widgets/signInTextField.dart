import 'package:flutter/material.dart';

TextField signInTextField({
  required TextEditingController controller,
  required String labelText,
  IconButton? iconButton = null,
  bool obscured = false,
  bool emailKeyboard = false,
}) {
  return TextField(
    keyboardType:
        emailKeyboard ? TextInputType.emailAddress : TextInputType.text,
    obscureText: obscured,
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: labelText,
      suffixIcon: iconButton,
    ),
  );
}
