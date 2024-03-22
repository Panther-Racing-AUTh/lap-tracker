import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/drawer_model.dart';
import 'package:provider/provider.dart';
import '../../widgets/block_widget.dart';
import '../../widgets/main_appbar.dart';

class MainScreen extends StatelessWidget {
  //static const String routeName = '/main-mobile';

  static const bool color = true;
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

    return LayoutBuilder(
      builder: (context, Constraints) {
        return Scaffold(
          appBar: MainAppBar(
            text: panther,
            context: context,
          ),
          // drawer: DrawerModel(context),
          // The main menu icons
          body: Container(
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
          ),
        );
      },
    );
  }
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
