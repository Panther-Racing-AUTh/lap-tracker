import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/admin_panel_screen.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/new_data_screen.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/proposal_screen.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/vehicle_screen.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:flutter_complete_guide/supabase/profile_functions.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:flutter_complete_guide/widgets/chats_total.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/create_new_vehicle_screen.dart';
import 'package:flutter_complete_guide/widgets/dark_theme_icons.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/proposals_desktop.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/data_desktop_widget.dart';
import 'package:flutter_complete_guide/widgets/profile_preview.dart';
import 'package:flutter_complete_guide/widgets/race_track_selector.dart';
import 'package:flutter_complete_guide/widgets/settings.dart';
import 'package:flutter_complete_guide/widgets/weather_widget.dart';
import 'package:provider/provider.dart';
import '../../names.dart' as names;
import '../../providers/app_setup.dart';
import '../../supabase/proposal_functions.dart';
import '../../widgets/desktop_widgets/charts_desktop_widget.dart';
import '../../widgets/desktop_widgets/panther_desktop_widget.dart';
import '../../widgets/desktop_widgets/profile_desktop_widget.dart';
import '../../widgets/diagram_comparison_button.dart';
import 'vehicle_setup_screen.dart';
import 'package:intl/intl.dart';

class MainScreenDesktop extends StatefulWidget {
  @override
  State<MainScreenDesktop> createState() => _MainScreenDesktopState();
}

class _MainScreenDesktopState extends State<MainScreenDesktop> {
  bool showSidebar = true;
  bool showWeather = true;
  bool showDriverBoard = true;
  late List<Widget> _Allpages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    AppSetup setup = Provider.of<AppSetup>(context, listen: false);

    _pageController = PageController(initialPage: setup.mainScreenDesktopIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //called when user clicks chart from message to open in 'charts' page
  void openChartInPage() {
    AppSetup setup = Provider.of<AppSetup>(context, listen: false);
    setState(() {
      setup.setIndex(setup.role == 'engineer' ? 1 : 2);
      _pageController.jumpToPage(setup.role == 'engineer' ? 1 : 2);
    });
  }

  //called to dynamically calculate width screen
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
    //list of all pages
    _Allpages = [
      DashBoardDesktop(width),
      ChatLandingPage(openChartInPage),
      NewDataScreen(),
      VehicleScreen(),
      AdminPanel(),
      SingleChildScrollView(child: ProfileDesktop()),
      Settings(),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // show/hide sidebar button
            IconButton(
              icon: Icon((showSidebar)
                  ? Icons.keyboard_double_arrow_left
                  : Icons.keyboard_double_arrow_right),
              onPressed: () => setState(() => showSidebar = !showSidebar),
            ),
            SizedBox(
              width: 10,
            ),
            ProfilePreview(),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(),
            ),
            //display weather information based on role
            if (setup.role != 'default' && setup.role != 'data_analyst')
              WeatherWidget(
                appbar: true,
                screenWidth: width,
              ),

            SizedBox(width: width * 0.1),
            //display time based on role
            // if (width > 620 &&
            //     setup.role != 'default' &&
            //     setup.role != 'data_analyst')
            //   StreamBuilder(
            //     stream: Stream.periodic(const Duration(seconds: 1)),
            //     builder: (context, snapshot) {
            //       return Text(
            //           DateFormat('MM/dd/yyyy hh:mm:ss').format(DateTime.now()));
            //     },
            //   ),
          ],
        ),

        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        //title: Text('Panther Racing AUTh'),
        actions: [
          //open proposal popup button
          if (setup.role == 'engineer')
            TextButton(
                onPressed: () => showProposal(context: context),
                child: Text(
                  'OPEN PROPOSAL',
                  style: TextStyle(color: Colors.white),
                )),
          SizedBox(width: 10),
          //button for user information
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('INFO', style: TextStyle(fontSize: 30)),
                      actions: [
                        Container(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Username: ',
                                    style: TextStyle(fontSize: 20)),
                                Text(setup.username,
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              children: [
                                Text('Email: ', style: TextStyle(fontSize: 20)),
                                Text(setup.userEmail,
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              children: [
                                Text('Department: ',
                                    style: TextStyle(fontSize: 20)),
                                Text(setup.userDepartment,
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              children: [
                                Text('Role: ', style: TextStyle(fontSize: 20)),
                                Text(setup.role, style: TextStyle(fontSize: 20))
                              ],
                            )
                          ],
                        ))
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.info)),
          //sign out button
          IconButton(
              onPressed: () => signOut(context), icon: Icon(Icons.exit_to_app)),
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
                    minHeight: height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight),
                child: IntrinsicHeight(
                  //side bar with pages
                  child: NavigationRail(
                    selectedIndex: setup.mainScreenDesktopInd,
                    groupAlignment: -1,
                    onDestinationSelected: (value) {
                      setState(() {
                        setup.setIndex(value);
                        _pageController.jumpToPage(value);
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    //dynamically display the available pages based on user role
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
            child: PageView(
              children: _pagesCustom(setup.role),
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
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
      text: 'Proposals',
      selectedIcon: Icon(Icons.dashboard),
    ),

    _widget(
      1,
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
      2,
      icon: Icon(Icons.bar_chart_outlined),
      text: names.chart,
      selectedIcon: Icon(Icons.bar_chart),
    ),

    _widget(
      3,
      icon: Icon(Icons.build),
      text: 'Vehicle Setup',
      selectedIcon: Icon(Icons.build),
    ),
    _widget(
      4,
      icon: Icon(Icons.admin_panel_settings_outlined),
      text: 'Admin Panel',
      selectedIcon: Icon(Icons.admin_panel_settings),
    ),
    _widget(
      5,
      icon: Icon(Icons.person_outlined),
      text: names.profile,
      selectedIcon: Icon(Icons.person),
    ),
    _widget(
      6,
      icon: Icon(Icons.settings_outlined),
      text: names.settings,
      selectedIcon: Icon(Icons.settings),
    ),
  ];
  //the custom page list based on user role
  List<Widget> _pagesCustom(String role) {
    List<Widget> l = [];
    if (role == 'admin') {
      l = [..._Allpages];
    }

    if (role == 'engineer') {
      l.add(_Allpages[1]);
      l.add(_Allpages[2]);
      l.add(_Allpages[5]);
      l.add(_Allpages[6]);
    }

    if (role == 'data_analyst') {
      l.add(_Allpages[2]);
      l.add(_Allpages[5]);
      l.add(_Allpages[6]);
    }

    if (role == 'default') {
      l.add(_Allpages[5]);
      l.add(_Allpages[6]);
    }

    if (role == 'hands_on_engineer') {
      l.add(_Allpages[0]);
      l.add(_Allpages[1]);
      l.add(_Allpages[2]);
      l.add(_Allpages[5]);
      l.add(_Allpages[6]);
    }

    if (role == 'chief_engineer') {
      l.add(_Allpages[0]);
      l.add(_Allpages[1]);
      l.add(_Allpages[2]);
      l.add(_Allpages[3]);
      l.add(_Allpages[5]);
      l.add(_Allpages[6]);
    }
    return l;
  }

  //custom destinations for available pages based on user role
  List<NavigationRailDestination> dynamicList(String role) {
    List<NavigationRailDestination> l = [];

    if (role == 'admin') {
      l.add(allNavigationRailDestinations[0]);
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[2]);
      l.add(allNavigationRailDestinations[3]);
      l.add(allNavigationRailDestinations[4]);
      l.add(allNavigationRailDestinations[5]);
      l.add(allNavigationRailDestinations[6]);
    }
    if (role == 'engineer') {
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[2]);
      l.add(allNavigationRailDestinations[5]);
      l.add(allNavigationRailDestinations[6]);
    }
    if (role == 'data_analyst') {
      l.add(allNavigationRailDestinations[2]);
      l.add(allNavigationRailDestinations[5]);
      l.add(allNavigationRailDestinations[6]);
    }
    if (role == 'default') {
      l.add(allNavigationRailDestinations[5]);
      l.add(allNavigationRailDestinations[6]);
    }
    if (role == 'hands_on_engineer') {
      l.add(allNavigationRailDestinations[0]);
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[2]);
      l.add(allNavigationRailDestinations[5]);
      l.add(allNavigationRailDestinations[6]);
    }
    if (role == 'chief_engineer') {
      l.add(allNavigationRailDestinations[0]);
      l.add(allNavigationRailDestinations[1]);
      l.add(allNavigationRailDestinations[2]);
      l.add(allNavigationRailDestinations[3]);
      l.add(allNavigationRailDestinations[5]);
      l.add(allNavigationRailDestinations[6]);
    }

    return l;
  }
}
