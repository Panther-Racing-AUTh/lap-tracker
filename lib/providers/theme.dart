import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool dark = false;

  ThemeData _lightTheme = lightTheme(Colors.indigo);
  ThemeData _darkTheme = darkTheme(Colors.indigo);

  ThemeChanger();

  ThemeData getLightTheme() => _lightTheme;
  ThemeData getDarkTheme() => _darkTheme;

  ThemeMode getCurrentThemeMode() => (dark) ? ThemeMode.dark : ThemeMode.light;

  switchTheme() {
    dark = !dark;
    notifyListeners();
  }

  setLightTheme(Color c) {
    _lightTheme = lightTheme(c as MaterialColor);
    notifyListeners();
  }

  setDarkTheme(Color c) {
    _darkTheme = darkTheme(c as MaterialColor);
    notifyListeners();
  }

  setThemeColor(Color c) {
    setLightTheme(c);
    setDarkTheme(c);
    notifyListeners();
  }
}

ThemeData darkTheme(MaterialColor c) => ThemeData(
      primarySwatch: c,
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
        ),
      ),
      canvasColor: Color.fromARGB(255, 41, 40, 40),
      accentColor: c,
      //accentIconTheme: IconThemeData(color: Colors.white),
      buttonColor: c,
      cardColor: c,
      primaryColor: c,
      iconTheme: IconThemeData(color: Colors.white),
    );

ThemeData lightTheme(MaterialColor c) => ThemeData(
      primarySwatch: c,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: IconThemeData(color: c),
      primaryIconTheme: IconThemeData(color: c),
    );
