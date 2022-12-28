import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/dashboard_desktop_widget.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/data_desktop_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/theme.dart';
import '../../supabase/authentication_functions.dart';
import '../../widgets/desktop_widgets/charts_desktop_widget.dart';
import '../../widgets/desktop_widgets/panther_desktop_widget.dart';
import '../../widgets/desktop_widgets/profile_desktop_widget.dart';

class MainScreenDesktop extends StatefulWidget {
  @override
  State<MainScreenDesktop> createState() => _MainScreenDesktopState();
}

class _MainScreenDesktopState extends State<MainScreenDesktop> {
  int _selected = 0;
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

    //Changes the size of the side menu widget depending on the window size

    return Scaffold(
      appBar: AppBar(
        title: Text('Panther Racing AUTh'),
        backgroundColor: Colors.blue,
        actions: [
          //dark theme toggle button
          IconButton(
            icon: theme.getTheme() == ThemeData.light()
                ? Icon(
                    Icons.light_mode_outlined,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.dark_mode_outlined,
                    color: Colors.white,
                  ),
            onPressed: (() {
              theme.getTheme() == ThemeData.light()
                  ? theme.setTheme(ThemeData.dark())
                  : theme.setTheme(ThemeData.light());
            }),
          )
        ],
      ),
      body: Row(
        //row with the menu blocks
        children: <Widget>[
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
              ),
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
                  ],
                  backgroundColor: Colors.lightBlue.withOpacity(0.15),
                  trailing: Column(
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      GestureDetector(
                        //sign out button
                        child: Container(
                          constraints:
                              BoxConstraints(minHeight: 40, minWidth: 40),
                          padding: EdgeInsets.only(bottom: 15),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.exit_to_app_rounded,
                                size: 27,
                              ),
                              Text(
                                (MediaQuery.of(context).size.width > 1000)
                                    ? 'Sign Out'
                                    : '',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          signOut();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context).pushReplacementNamed('/signin');
                        },
                      ),
                    ],
                  ),
                  selectedLabelTextStyle:
                      TextStyle(color: Colors.blue, fontSize: 20),
                  unselectedLabelTextStyle: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .headline6!
                          .backgroundColor,
                      fontSize: 20),
                  selectedIconTheme:
                      IconThemeData(size: 27, color: Colors.blue),
                  unselectedIconTheme: IconThemeData(size: 27),
                ),
              ),
            ),
          ),

          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.black,
          ),

          //depending on the selected block above,
          //a different widget is rendered on the right side of screen
          Expanded(
            //flex: ,
            child: Container(
              child: buildPages(height),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPages(double height) {
    switch (_selected) {
      case 0:
        return DashBoardDesktop(screenHeight: height);

      case 1:
        return SingleChildScrollView(
          child: ProfileDesktop(),
        );
      case 2:
        return Container(child: ChatWidget() //, width: width - blockWidth - 1,
            );
      case 3:
        return DataDesktopWidget(
          key: UniqueKey(),
        );
      case 4:
        return ChartDesktop();
      case 5:
        return PantherDesktop();
    }
    return CircularProgressIndicator();
  }
}
