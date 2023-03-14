import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/admin_panel_screen.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/new_data_screen.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:flutter_complete_guide/widgets/chats_total.dart';
import 'package:flutter_complete_guide/widgets/dark_theme_icons.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/dashboard_desktop_widget.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/data_desktop_widget.dart';
import 'package:flutter_complete_guide/widgets/race_track_selector.dart';
import 'package:flutter_complete_guide/widgets/settings.dart';
import 'package:flutter_complete_guide/widgets/weather_widget.dart';
import 'package:provider/provider.dart';
import '../../names.dart' as names;
import '../../providers/app_setup.dart';
import '../../widgets/desktop_widgets/charts_desktop_widget.dart';
import '../../widgets/desktop_widgets/panther_desktop_widget.dart';
import '../../widgets/desktop_widgets/profile_desktop_widget.dart';
import '../../widgets/diagram_comparison_button.dart';
import '../../widgets/motorcycle_setup.dart';

class MainScreenDesktop extends StatefulWidget {
  @override
  State<MainScreenDesktop> createState() => _MainScreenDesktopState();
}

class _MainScreenDesktopState extends State<MainScreenDesktop> {
  bool showSidebar = true;
  bool showWeather = true;
  bool showDriverBoard = true;

  double _calculateAvailableWidthOfScreen(double deviceScreenWidth) {
    if (showSidebar) {
      if (deviceScreenWidth > 1000) {
        return deviceScreenWidth - 114;
      }
      return deviceScreenWidth - 73;
    }
    return deviceScreenWidth;
  }

  @override
  Widget build(BuildContext context) {
    AppSetup setup = Provider.of<AppSetup>(context);
    var height = MediaQuery.of(context).size.height;
    var width =
        _calculateAvailableWidthOfScreen(MediaQuery.of(context).size.width);

    Widget buildPages(double height) {
      switch (allNavigationRailDestinations.indexWhere((element) =>
          element == dynamicList(setup.role)[setup.mainScreenDesktopIndex])) {
        case 0:
          return DashBoardDesktop(
            showWeather: showWeather,
            showDriverBoard: showDriverBoard,
            screenHeight: height,
            screenWidth: width,
          );
        case 1:
          return SingleChildScrollView(child: ProfileDesktop());
        case 2:
          return ChatLandingPage();

        case 3:
          return NewDataScreen();
        case 4:
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
        case 5:
          return AdminPanel();
      }
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: //button for panel collapse
            Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon((showSidebar)
                  ? Icons.keyboard_double_arrow_left
                  : Icons.keyboard_double_arrow_right),
              onPressed: () => setState(() => showSidebar = !showSidebar),
            ),
            SizedBox(
              width: 10,
            ),
            WeatherWidget(
              appbar: true,
              screenWidth: MediaQuery.of(context).size.width,
            )
          ],
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        //title: Text('Panther Racing AUTh'),
        actions: [
          DiagramComparison(context),
          SizedBox(width: 10),
          IconButton(
            onPressed: () => motorcycleSetup(context: context),
            icon: Icon(
              Icons.motorcycle,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              setup.setValuesAuto();
            },
          ),
          SizedBox(width: 10),
          //RaceTrackSelector(),
          SizedBox(width: 10),
          //dark theme toggle button
          DarkThemeButton(context: context, lightThemeColor: Colors.white),
          SizedBox(width: 5),
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
                    selectedIndex: setup.mainScreenDesktopInd,
                    groupAlignment: -1,
                    onDestinationSelected: (value) {
                      setState(() {
                        setup.setIndex(value);
                        //setup.setIndex(allNavigationRailDestinations.indexWhere(
                        //    (element) =>
                        //        element == dynamicList(setup.role)[value]));
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: dynamicList(setup.role),
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
                        color: Theme.of(context).textTheme.headline6!.color),
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
    );
  }

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

  late List<NavigationRailDestination> allNavigationRailDestinations = [
    _widget(
      0,
      icon: Icon(Icons.dashboard_outlined),
      text: names.dashboard,
      selectedIcon: Icon(Icons.dashboard),
    ),
    _widget(
      1,
      icon: Icon(Icons.person_outlined),
      text: names.profile,
      selectedIcon: Icon(Icons.person),
    ),
    _widget(
      2,
      icon: Icon(Icons.chat_outlined),
      text: names.chat,
      selectedIcon: Icon(Icons.chat),
    ),
    //_widget(
    //  3,
    //  icon: Icon(Icons.data_object_outlined),
    //  text: names.data,
    //  selectedIcon: Icon(Icons.data_object),
    //),
    _widget(
      3,
      icon: Icon(Icons.bar_chart_outlined),
      text: names.chart,
      selectedIcon: Icon(Icons.bar_chart),
    ),
    _widget(
      4,
      icon: Icon(Icons.settings_outlined),
      text: names.settings,
      selectedIcon: Icon(Icons.settings),
    ),
    _widget(
      5,
      icon: Icon(Icons.admin_panel_settings_outlined),
      text: 'Admin Panel',
      selectedIcon: Icon(Icons.admin_panel_settings),
    )
  ];

  List<NavigationRailDestination> dynamicList(String role) {
    List<NavigationRailDestination> l = [];

    if (role == 'admin') {
      l.add(allNavigationRailDestinations[0]);
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[2]);
      l.add(allNavigationRailDestinations[3]);
      l.add(allNavigationRailDestinations[4]);
      l.add(allNavigationRailDestinations[5]);
    }
    if (role == 'engineer') {
      l.add(allNavigationRailDestinations[0]);
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[2]);
      l.add(allNavigationRailDestinations[3]);
      l.add(allNavigationRailDestinations[4]);
    }
    if (role == 'data_analyst') {
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[3]);
      l.add(allNavigationRailDestinations[4]);
    }
    if (role == 'default') {
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[4]);
    }
    return l;
  }
}
