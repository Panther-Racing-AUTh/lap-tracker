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

Widget DarkThemeButton(
    {required BuildContext context,
    Color lightThemeColor = Colors.black,
    Color darkThemeColor = Colors.white}) {
  ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
  return IconButton(
    icon: _themeChanger.getCurrentThemeMode() == ThemeMode.light
        ? Icon(
            Icons.light_mode_outlined,
            color: lightThemeColor,
          )
        : Icon(
            Icons.dark_mode_outlined,
            color: darkThemeColor,
          ),
    onPressed: (() {
      _themeChanger.switchTheme();
    }),
  );
}
