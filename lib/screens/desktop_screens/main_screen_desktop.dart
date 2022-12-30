import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/dashboard_desktop_widget.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/data_desktop_widget.dart';
import 'package:flutter_complete_guide/widgets/settings.dart';
import 'package:provider/provider.dart';
import '../../providers/theme.dart';
import '../../widgets/desktop_widgets/charts_desktop_widget.dart';
import '../../widgets/desktop_widgets/panther_desktop_widget.dart';
import '../../widgets/desktop_widgets/profile_desktop_widget.dart';

class MainScreenDesktop extends StatefulWidget {
  @override
  State<MainScreenDesktop> createState() => _MainScreenDesktopState();
}

class _MainScreenDesktopState extends State<MainScreenDesktop> {
  int _selected = 0;
  bool showSidebar = true;
  bool showWeather = true;
  NavigationRailDestination _widget(
    //widget for each tab on the left of the screen, each block has a unique index
    //which can determine which block is selected and show appropriate widget on the right
    int index, {
    required Icon selectedIcon,
    required Icon icon,
    required String text,
  }) {
    return NavigationRailDestination(
      icon: icon,
      selectedIcon: selectedIcon,
      label: Text(
        (MediaQuery.of(context).size.width > 1000) ? text : '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger theme = Provider.of<ThemeChanger>(context);

    var height = MediaQuery.of(context).size.height;

    Widget buildPages(double height) {
      switch (_selected) {
        case 0:
          return DashBoardDesktop(showWeather: showWeather);
        case 1:
          return SingleChildScrollView(child: ProfileDesktop());
        case 2:
          return Container(child: ChatWidget());
        case 3:
          return DataDesktopWidget();
        case 4:
          return ChartDesktop();
        case 5:
          return PantherDesktop();
        case 6:
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height - kToolbarHeight),
              child: IntrinsicHeight(
                child: Settings(),
              ),
            ),
          );
      }
      return CircularProgressIndicator();
    }

    return CallbackShortcuts(
      bindings: shortcuts(_selected),
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            leading: //button for panel collapse
                IconButton(
              icon: Icon((showSidebar)
                  ? Icons.keyboard_double_arrow_left
                  : Icons.keyboard_double_arrow_right),
              onPressed: () => setState(() => showSidebar = !showSidebar),
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text('Panther Racing AUTh'),
            actions: [
              //dark theme toggle button
              IconButton(
                icon: theme.getCurrentThemeMode() == ThemeMode.light
                    ? Icon(
                        Icons.light_mode_outlined,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.dark_mode_outlined,
                        color: Colors.white,
                      ),
                onPressed: (() {
                  theme.switchTheme();
                }),
              )
            ],
          ),
          body: Row(
            //row with the menu blocks
            children: <Widget>[
              Visibility(
                visible: showSidebar,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            kToolbarHeight),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        selectedIndex: _selected,
                        groupAlignment: -1,
                        onDestinationSelected: (value) {
                          setState(() {
                            _selected = value;
                          });
                        },
                        labelType: NavigationRailLabelType.all,
                        destinations: <NavigationRailDestination>[
                          _widget(
                            0,
                            icon: Icon(Icons.dashboard_outlined),
                            text: 'Dashboard',
                            selectedIcon: Icon(Icons.dashboard),
                          ),
                          _widget(
                            1,
                            icon: Icon(Icons.person_outlined),
                            text: 'Profile',
                            selectedIcon: Icon(Icons.person),
                          ),
                          _widget(
                            2,
                            icon: Icon(Icons.chat_outlined),
                            text: 'Chat',
                            selectedIcon: Icon(Icons.chat),
                          ),
                          _widget(
                            3,
                            icon: Icon(Icons.data_object_outlined),
                            text: 'Data',
                            selectedIcon: Icon(Icons.data_object),
                          ),
                          _widget(
                            4,
                            icon: Icon(Icons.bar_chart_outlined),
                            text: 'Charts',
                            selectedIcon: Icon(Icons.bar_chart),
                          ),
                          _widget(
                            5,
                            icon: Icon(Icons.star_border),
                            text: 'Panther',
                            selectedIcon: Icon(Icons.star),
                          ),
                          _widget(
                            6,
                            icon: Icon(Icons.settings_outlined),
                            text: 'Settings',
                            selectedIcon: Icon(Icons.settings),
                          ),
                        ],
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.15),
                        selectedLabelTextStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                        unselectedLabelTextStyle: TextStyle(
                            color: Theme.of(context).textTheme.headline6!.color,
                            fontSize: 20),
                        selectedIconTheme: IconThemeData(
                          color: Theme.of(context).primaryColor,
                          size: 27,
                        ),
                        unselectedIconTheme: IconThemeData(
                            size: 27,
                            color:
                                Theme.of(context).textTheme.headline6!.color),
                      ),
                    ),
                  ),
                ),
              ),

              if (showSidebar)
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.black,
                ),

              //depending on the selected block above,
              //a different widget is rendered on the right side of screen

              Expanded(
                child: Container(
                  child: buildPages(height),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //shortcuts
  Map<ShortcutActivator, void Function()> shortcuts(int index) {
    return {
      const SingleActivator(
        LogicalKeyboardKey.keyM,
      ): () {
        setState(() {
          showSidebar = !showSidebar;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit1,
      ): () {
        setState(() {
          if (_selected == 0) showWeather = !showWeather;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit1,
        control: true,
      ): () {
        setState(() {
          _selected = 0;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit2,
        control: true,
      ): () {
        setState(() {
          _selected = 1;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit3,
        control: true,
      ): () {
        setState(() {
          _selected = 2;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit4,
        control: true,
      ): () {
        setState(() {
          _selected = 3;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit5,
        control: true,
      ): () {
        setState(() {
          _selected = 4;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit6,
        control: true,
      ): () {
        setState(() {
          _selected = 5;
        });
      },
      const SingleActivator(
        LogicalKeyboardKey.digit7,
        control: true,
      ): () {
        setState(() {
          _selected = 6;
        });
      },
    };
  }
}
