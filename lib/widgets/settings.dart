import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/providers/device.dart';
import 'package:flutter_complete_guide/providers/settings_providers/settings.dart';
import 'package:flutter_complete_guide/providers/theme.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/about_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:flutter_complete_guide/widgets/dark_theme_icons.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final device = Provider.of<DeviceManager>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Style Settings",
                style: TextStyle(
                  color: Colors.black.withOpacity(.3),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      DarkThemeSwitch(context: context),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .5,

                        child: Text(
                          'Homepage Style:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      Switch(
                        value: settingsProvider.isNewHomepage,
                        onChanged: (value) {
                          settingsProvider.setIsNewHomepage(value);
                        },
                      ),
                    ],
                  )

                ],
              ),
            ),

            SizedBox(height: 30),
            Text(
              'Select Theme Color',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: 10,
                children: List.generate(
                  10,
                      (index) => GestureDetector(
                    onTap: () {
                      theme.setThemeColor(_getColorByIndex(index), index);
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _getColorByIndex(index),
                        border: Border.all(
                          color: theme.colorIndex == index
                              ? Theme.of(context).cardColor
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
            if (!device.isDesktopMode() && !device.isPhone)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    device.setToDesktopMode();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacementNamed('/main-desktop');
                  },
                  child: Text('Switch to Desktop View'),
                ),
              ),
            if (device.isDesktopMode())
              ElevatedButton(
                onPressed: () {
                  device.setToMobileMode();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacementNamed('/main-mobile');
                },
                child: Text('Switch to Mobile View'),
              ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  signOut(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        
      ),
    );
  }

  Color _getColorByIndex(int index) {
    switch (index) {
      case 0:
        return Colors.indigo;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.yellow;
      case 6:
        return Colors.orange;
      case 7:
        return Colors.pink;
      case 8:
        return Colors.cyan;
      case 9:
        return Colors.lime;
      default:
        return Colors.grey;
    }
  }
}
