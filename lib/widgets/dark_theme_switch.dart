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
        color: _themeChanger.getTheme() == ThemeData.dark()
            ? Colors.white
            : Colors.black,
      ),
      Switch(
        value: _themeChanger.getTheme() == ThemeData.dark(),
        onChanged: (value) {
          value
              ? _themeChanger.setTheme(ThemeData.dark())
              : _themeChanger.setTheme(ThemeData.light());
        },
        inactiveTrackColor: Colors.grey,
      ),
      Icon(
        Icons.dark_mode_outlined,
        color: _themeChanger.getTheme() == ThemeData.dark()
            ? Colors.white
            : Colors.black,
      )
    ],
  );
}
