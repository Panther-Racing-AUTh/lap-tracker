import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme.dart';
import '../supabase/authentication_functions.dart';
import 'dark_theme_switch.dart';

Widget Settings(BuildContext context) {
  final theme = Provider.of<ThemeChanger>(context);

  Widget coloredBox({required Color color}) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 50,
        color: color,
      ),
      onTap: () => theme.setThemeColor(color),
    );
  }

  return Container(
    height: double.infinity,
    width: double.infinity,
    child: Column(
      children: [
        SizedBox(
          height: 30,
        ),
        DarkThemeSwitch(context: context),
        SizedBox(
          height: 40,
        ),
        OutlinedButton(
          child: Text(
            "Sign out",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: () {
            signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacementNamed('/signin');
          },
        ),
        SizedBox(
          height: 50,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                coloredBox(
                  color: Colors.indigo,
                ),
                SizedBox(
                  width: 10,
                ),
                coloredBox(
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                coloredBox(
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                coloredBox(
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                coloredBox(
                  color: Colors.yellow,
                ),
                SizedBox(
                  width: 10,
                ),
                coloredBox(
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 10,
                ),
                coloredBox(
                  color: Colors.pink,
                ),
                SizedBox(
                  width: 10,
                ),
                coloredBox(
                  color: Colors.cyan,
                ),
                SizedBox(
                  width: 10,
                ),
                coloredBox(
                  color: Colors.lime,
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}
