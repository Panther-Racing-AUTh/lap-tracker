import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool dark = false;
  int colorIndex = 0;

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

  setIndex(int id) {
    colorIndex = id;
  }

  setLightTheme(Color c) {
    _lightTheme = lightTheme(c as MaterialColor);
    notifyListeners();
  }

  setDarkTheme(Color c) {
    _darkTheme = darkTheme(c as MaterialColor);
    notifyListeners();
  }

  setThemeColor(Color c, int id) {
    setLightTheme(c);
    setDarkTheme(c);
    setIndex(id);
    notifyListeners();
  }
}

ThemeData darkTheme(MaterialColor c) => ThemeData(
      primarySwatch: c,

      brightness: Brightness.dark,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
        ),
      ),
      canvasColor: Color.fromARGB(255, 41, 40, 40),

      //accentIconTheme: IconThemeData(color: Colors.white),
      buttonTheme:
          ButtonThemeData(colorScheme: ColorScheme.fromSeed(seedColor: c)),
      cardColor: c,
      primaryColor: c,
      iconTheme: IconThemeData(color: Colors.white),
      secondaryHeaderColor: Colors.white,
      colorScheme:  ColorScheme.dark(
        background: Colors.black,
      ),
    );

ThemeData lightTheme(MaterialColor c) => ThemeData(
      primarySwatch: c,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
        ),
      ),
      cardColor: c.shade200,
      iconTheme: IconThemeData(color: c),
      primaryIconTheme: IconThemeData(color: c),
      secondaryHeaderColor: Colors.black,
      colorScheme: ColorScheme.light(
        background: Colors.grey.shade300,
      ),
    );
