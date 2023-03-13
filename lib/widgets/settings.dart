import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/providers/device.dart';
import 'package:provider/provider.dart';
import '../providers/app_setup.dart';
import '../providers/theme.dart';
import '../supabase/authentication_functions.dart';
import 'dark_theme_icons.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    AppSetup a = Provider.of<AppSetup>(context);
    final theme = Provider.of<ThemeChanger>(context);
    final device = Provider.of<DeviceManager>(context);
    int selectedColor = theme.colorIndex;
    Widget coloredBox({required Color color, required int id}) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: (selectedColor == id)
                ? Theme.of(context).selectedRowColor
                : Colors.transparent,
            width: 3,
          ),
        ),
        child: GestureDetector(
          child: Container(
            height: 50,
            width: 50,
            color: color,
          ),
          onTap: () {
            setState(() {
              selectedColor = id;
            });
            theme.setThemeColor(color, id);
          },
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(bottom: 50),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          DarkThemeSwitch(context: context),
          SizedBox(
            height: 40,
          ),
          OutlinedButton(
            child: Text(
              sign_out,
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
            onPressed: () async {
              signOut(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacementNamed('/signin');
              await Future.delayed(Duration(seconds: 2));
              a.setIndex(0);
              a.role = '';
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
                    id: 0,
                    color: Colors.indigo,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 1,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 2,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 3,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 4,
                    color: Colors.purple,
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
                    id: 5,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 6,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 7,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 8,
                    color: Colors.cyan,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  coloredBox(
                    id: 9,
                    color: Colors.lime,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              if (!device.isDesktopMode() && !device.isPhone)
                TextButton(
                  child: Text(switch_desktop),
                  onPressed: () {
                    device.setToDesktopMode();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacementNamed('/main-desktop');
                  },
                ),
              if (device.isDesktopMode())
                TextButton(
                  child: Text(switch_mobile),
                  onPressed: () {
                    device.setToMobileMode();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacementNamed('/main-mobile');
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
