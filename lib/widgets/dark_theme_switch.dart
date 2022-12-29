import 'package:flutter/material.dart';
import '../providers/theme.dart';
import 'package:provider/provider.dart';

Row DarkThemeSwitch({required BuildContext context}) {
  ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.light_mode_outlined,
        color: _themeChanger.getCurrentThemeMode() == ThemeMode.dark
            ? Colors.white
            : Colors.black,
      ),
      Switch(
        value: _themeChanger.getCurrentThemeMode() == ThemeMode.dark,
        onChanged: (_) {
          _themeChanger.switchTheme();
        },
        inactiveTrackColor: Colors.grey,
        activeColor: _themeChanger.getLightTheme().primaryColor,
      ),
      Icon(
        Icons.dark_mode_outlined,
        color: _themeChanger.getCurrentThemeMode() == ThemeMode.dark
            ? Colors.white
            : Colors.black,
      )
    ],
  );
}
