import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/about_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/drawer_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/models/carousel_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/settings_screen.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:provider/provider.dart';
import '../../widgets/block_widget.dart';
import '../../widgets/main_appbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //static const String routeName = '/main-mobile';

  static const bool color = true;
  bool oldUi = false;
  void _showAccountPopupMenu(BuildContext context, int viewIndex) {
    late bool getBool;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final double buttonWidth = button.size.width;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double dx = screenWidth;
    final double dy = 100;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      items: [
        PopupMenuItem<String>(
          value: 'Option 1',
          onTap: () {
            setState(() {});
            if (viewIndex == DrawerIndexValue.home.getInt()) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ));
            }
          },
          child: Row(
            children: [
              Icon(Icons.account_circle),
              SizedBox(
                width: 10,
              ),
              Text('Profile')
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Option 1',
          onTap: () {
            setState(() {});

            if (viewIndex == DrawerIndexValue.home.getInt()) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ));
            }
          },
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(
                width: 10,
              ),
              Text('Settings')
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Option 1',
          onTap: () {
            setState(() {});

            if (viewIndex == DrawerIndexValue.home.getInt()) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ));
            }
          },
          child: Row(
            children: [
              Icon(Icons.info),
              SizedBox(
                width: 10,
              ),
              Text('About')
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Option 1',
          onTap: () {
            setState(() {
              oldUi = !oldUi;
            });
          },
          child: Row(
            children: [
              Icon(Icons.refresh_sharp),
              SizedBox(
                width: 10,
              ),
              Text(oldUi ? 'New UI' : 'Old UI')
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Option 1',
          onTap: () {
            setState(() {
              signOut(context);
            });
          },
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(
                width: 10,
              ),
              Text('Logout`')
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSetup appSetup = Provider.of<AppSetup>(context);

    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    //all blocks list - each blocks maps to a different page
    List<Widget> allBlocks = [
      blockWidget(
        title: profile,
        context: context,
        color: Color.fromARGB(255, 18, 64, 102),
        page: '/profile',
        icon: Icons.switch_account,
      ),
      blockWidget(
        title: chat,
        context: context,
        color: Color.fromARGB(255, 38, 67, 161),
        page: '/chat',
        icon: Icons.chat,
      ),
      blockWidget(
        title: data,
        context: context,
        color: Color.fromARGB(255, 235, 227, 215),
        page: '/data',
        icon: Icons.data_object,
      ),
      blockWidget(
        title: "Calendar",
        context: context,
        color: Color.fromARGB(255, 7, 34, 56),
        page: '/calendar',
        icon: Icons.calendar_month_outlined,
      ),
      blockWidget(
        title: chart,
        context: context,
        color: Color.fromARGB(255, 85, 139, 190),
        page: '/chart',
        icon: Icons.bar_chart_rounded,
      ),
      blockWidget(
        title: "Admin Panel",
        context: context,
        color: Color.fromARGB(255, 7, 34, 56),
        page: '/admin-panel-mobile',
        icon: Icons.admin_panel_settings,
      ),
      blockWidget(
        title: settings,
        context: context,
        color: Color.fromARGB(255, 169, 228, 200),
        page: '/settings',
        icon: Icons.settings,
      ),
    ];
    oldUI() {
      return Container(
        // color: Colors.pink,
        padding: const EdgeInsets.all(25),
        //Created a big column that includes the 6 menu boxes
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: landscape ? 3 : 2,
            mainAxisSpacing: 50,
            crossAxisSpacing: 40,
            childAspectRatio: 0.7,
          ),
          scrollDirection: Axis.vertical,
          children: (appSetup.supabase_id == -1)
              ? [Center(child: CircularProgressIndicator())]
              : dynamicBlocks(allBlocks: allBlocks, role: appSetup.role),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, Constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(panther),
            actions: [
              GestureDetector(
                  onTap: () {
                    _showAccountPopupMenu(
                        context, DrawerIndexValue.home.getInt());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25)),
                    child: Image.asset(
                      'assets/panther_logo_transparent.png',
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.account_circle,
                        size: 40,
                      ),
                    ),
                  ))
            ],
          ),
          backgroundColor: Color(-16289889),
          drawer: DrawerModel(context, DrawerIndexValue.home.getInt()),
          // The main menu icons
          body: oldUi
              ? oldUI()
              : Container(
                  child: Stack(children: [
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: CutsomCarouselWidget(
                            height: 150,
                            itemList:
                                getRoleList(role: appSetup.role)['item_list'],
                            iconList:
                                getRoleList(role: appSetup.role)['icon_list'],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.shade700,
                                    Colors.grey.shade200
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                            ),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Center(
                                    child: Text(
                                  'Data',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: Text('See All')),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(25)),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Center(
                                    child: Text(
                                  'Data',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: Text('See All')),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(25)),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
        );
      },
    );
  }
}

Map<String, dynamic> getRoleList({required String role}) {
  Map<String, dynamic> tempMap = {
    'item_list': [],
    'icon_list': [],
  };
  switch (role) {
    case 'admin':
      tempMap['item_list'] = [
        'Profile',
        'Chat',
        'Data',
        'Calendar',
        'Chart',
        'Admin Panel',
        'Settings'
      ];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.chat,
          size: 35,
        ),
        Icon(
          Icons.data_object,
          size: 35,
        ),
        Icon(
          Icons.calendar_month,
          size: 35,
        ),
        Icon(
          Icons.bar_chart,
          size: 35,
        ),
        Icon(
          Icons.admin_panel_settings,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
    case 'engineer':
      tempMap['item_list'] = [
        'Profile',
        'Chat',
        'Data',
        'Calendar',
        'Chart',
        'Settings'
      ];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.chat,
          size: 35,
        ),
        Icon(
          Icons.data_object,
          size: 35,
        ),
        Icon(
          Icons.calendar_month,
          size: 35,
        ),
        Icon(
          Icons.bar_chart,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
    case 'chief_engineer':
      tempMap['item_list'] = [
        'Profile',
        'Chat',
        'Data',
        'Calendar',
        'Chart',
        'Settings'
      ];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.chat,
          size: 35,
        ),
        Icon(
          Icons.data_object,
          size: 35,
        ),
        Icon(
          Icons.calendar_month,
          size: 35,
        ),
        Icon(
          Icons.bar_chart,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
    case 'hands_on_engineer':
      tempMap['item_list'] = [
        'Profile',
        'Chat',
        'Data',
        'Calendar',
        'Chart',
        'Settings'
      ];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.chat,
          size: 35,
        ),
        Icon(
          Icons.data_object,
          size: 35,
        ),
        Icon(
          Icons.calendar_month,
          size: 35,
        ),
        Icon(
          Icons.bar_chart,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
    case 'member':
      tempMap['item_list'] = [
        'Profile',
        'Chat',
        'Data',
        'Calendar',
        'Chart',
        'Settings'
      ];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.chat,
          size: 35,
        ),
        Icon(
          Icons.data_object,
          size: 35,
        ),
        Icon(
          Icons.calendar_month,
          size: 35,
        ),
        Icon(
          Icons.bar_chart,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
    case 'coordinator':
      tempMap['item_list'] = [
        'Profile',
        'Chat',
        'Data',
        'Calendar',
        'Chart',
        'Settings'
      ];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.chat,
          size: 35,
        ),
        Icon(
          Icons.data_object,
          size: 35,
        ),
        Icon(
          Icons.calendar_month,
          size: 35,
        ),
        Icon(
          Icons.bar_chart,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
    case 'default':
      tempMap['item_list'] = ['Profile', 'Settings'];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
    case 'data_analyst':
      tempMap['item_list'] = [
        'Profile',
        'Data',
        'Calendar',
        'Chart',
        'Settings'
      ];
      tempMap['icon_list'] = [
        Icon(
          Icons.account_circle,
          size: 35,
        ),
        Icon(
          Icons.data_object,
          size: 35,
        ),
        Icon(
          Icons.calendar_month,
          size: 35,
        ),
        Icon(
          Icons.bar_chart,
          size: 35,
        ),
        Icon(
          Icons.settings,
          size: 35,
        )
      ];
  }
  ;
  return tempMap;
}

dynamicBlocks({required List<Widget> allBlocks, required String role}) {
  List<Widget> l = [];
  if (role == 'admin') {
    l = [...allBlocks];
  }
  if (role == 'engineer' ||
      role == 'chief_engineer' ||
      role == 'hands_on_engineer') {
    l.add(allBlocks[0]);
    l.add(allBlocks[1]);
    l.add(allBlocks[2]);
    l.add(allBlocks[3]);
    l.add(allBlocks[4]);
    l.add(allBlocks[6]);
  }
  if (role == 'member') {
    l.add(allBlocks[0]);
    l.add(allBlocks[1]);
    l.add(allBlocks[2]);
    l.add(allBlocks[3]);
    l.add(allBlocks[4]);
    l.add(allBlocks[6]);
  }
  if (role == 'coordinator') {
    l.add(allBlocks[0]);
    l.add(allBlocks[1]);
    l.add(allBlocks[2]);
    l.add(allBlocks[3]);
    l.add(allBlocks[4]);
    l.add(allBlocks[6]);
  }
  if (role == 'default') {
    l.add(allBlocks[0]);
    l.add(allBlocks[6]);
  }
  if (role == 'data_analyst') {
    l.add(allBlocks[0]);
    l.add(allBlocks[2]);
    l.add(allBlocks[4]);
    l.add(allBlocks[6]);
  }
  return l;
}
