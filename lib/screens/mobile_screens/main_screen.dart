import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
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
            text: panther,
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
                        title: profile,
                        context: context,
                        color: Color.fromARGB(255, 18, 64, 102),
                        page: '/profile',
                        icon: Icons.switch_account,
                      ),
                    ),
                    Container(
                      child: blockWidget(
                        title: chat,
                        context: context,
                        color: Color.fromARGB(255, 38, 67, 161),
                        page: '/chat',
                        icon: Icons.chat,
                      ),
                    ),
                    if (landscape)
                      Container(
                        child: blockWidget(
                          title: data,
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
                          title: data,
                          context: context,
                          color: Color.fromARGB(255, 235, 227, 215),
                          page: '/data',
                          icon: Icons.data_object,
                        ),
                      ),
                    Container(
                      child: blockWidget(
                        title: settings,
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
                          title: panther,
                          context: context,
                          color: Color.fromARGB(255, 7, 34, 56),
                          page: '/panther',
                          icon: Icons.auto_delete,
                        ),
                      ),
                    if (landscape)
                      Container(
                        child: blockWidget(
                          title: chart,
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
                          title: panther,
                          context: context,
                          color: Color.fromARGB(255, 7, 34, 56),
                          page: '/panther',
                          icon: Icons.auto_delete,
                        ),
                      ),
                      // Chart BlockWidget Ignore for now the root
                      Container(
                        child: blockWidget(
                          title: chart,
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
