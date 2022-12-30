import 'package:flutter/material.dart';
import '../../widgets/block_widget.dart';
import '../../widgets/main_appbar.dart';

class MainScreen extends StatelessWidget {
  //static const String routeName = '/main-mobile';

  static const bool color = true;
  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return LayoutBuilder(
      builder: (context, Constraints) {
        return Scaffold(
          appBar: MainAppBar(
            text: 'Panther Racing AUTh',
            context: context,
          ),
          // The main menu icons
          body: Container(
            padding: const EdgeInsets.all(25),
            //Created a big column that includes the 6 menu boxes
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Created 3 Rows, each row has 2 menu boxes in portrait mode.
                //In Landscape mode there are 2 rows, each with 3 menu boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Created a column that contains 1 menu box
                    Container(
                      child:
                          //Widget created
                          blockWidget(
                        title: 'Profile',
                        context: context,
                        color: Color.fromARGB(255, 18, 64, 102),
                        page: '/profile',
                        icon: Icons.switch_account,
                      ),
                    ),
                    Container(
                      child: blockWidget(
                        title: 'Chat',
                        context: context,
                        color: Color.fromARGB(255, 38, 67, 161),
                        page: '/chat',
                        icon: Icons.chat,
                      ),
                    ),
                    if (landscape)
                      Container(
                        child: blockWidget(
                          title: 'Data',
                          context: context,
                          color: Color.fromARGB(255, 235, 227, 215),
                          page: '/data',
                          icon: Icons.data_object,
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!landscape)
                      Container(
                        child: blockWidget(
                          title: 'Data',
                          context: context,
                          color: Color.fromARGB(255, 235, 227, 215),
                          page: '/data',
                          icon: Icons.data_object,
                        ),
                      ),
                    Container(
                      child: blockWidget(
                        title: 'Settings',
                        context: context,
                        color: Color.fromARGB(255, 169, 228, 200),
                        page: '/settings',
                        icon: Icons.settings,
                      ),
                    ),
                    if (landscape)
                      Container(
                        child:
                            //Widget created
                            blockWidget(
                          title: 'Panther',
                          context: context,
                          color: Color.fromARGB(255, 7, 34, 56),
                          page: '/panther',
                          icon: Icons.auto_delete,
                        ),
                      ),
                    if (landscape)
                      Container(
                        child: blockWidget(
                          title: 'Charts',
                          context: context,
                          color: Color.fromARGB(255, 85, 139, 190),
                          page: '/chart',
                          icon: Icons.bar_chart_rounded,
                        ),
                      ),
                  ],
                ),
                if (!landscape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Created a column that contains 1 menu box
                      Container(
                        //Widget created
                        child: blockWidget(
                          title: 'Panther',
                          context: context,
                          color: Color.fromARGB(255, 7, 34, 56),
                          page: '/panther',
                          icon: Icons.auto_delete,
                        ),
                      ),
                      // Chart BlockWidget Ignore for now the root
                      Container(
                        child: blockWidget(
                          title: 'Charts',
                          context: context,
                          color: Color.fromARGB(255, 85, 139, 190),
                          page: '/chart',
                          icon: Icons.bar_chart_rounded,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
