import 'package:flutter/material.dart';
import '../../supabase/authentication_functions.dart';
import '../../widgets/dark_theme_switch.dart';
import '../../widgets/main_appbar.dart';

class SettingsScreen extends StatelessWidget {
  //static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: 'Settings',
        context: context,
      ),
      body: Container(
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
            )
          ],
        ),
      ),
    );
  }
}
