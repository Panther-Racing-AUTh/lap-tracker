import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/supabase/select_race_track_functions.dart';
import 'package:flutter_complete_guide/widgets/create_new_vehicle_screen.dart';
import 'package:flutter_complete_guide/widgets/drivers_grid.dart';
import 'package:provider/provider.dart';

import '../../providers/app_setup.dart';
import '../../supabase/authentication_functions.dart';
import '../overview.dart';

class _MyDelegate extends MultiChildLayoutDelegate {
  _MyDelegate(
      {required this.position,
      required this.screenHeight,
      required this.screenWidth});

  final Offset position;
  final double screenHeight;
  final double screenWidth;

  @override
  void performLayout(Size size) {
    late Size firstSize;
    late Size secondSize;
    late Size thirdSize;

    //if (hasChild(1)) {
    //  firstSize = layoutChild(
    //    1,
    //    BoxConstraints(),
    //  );
//
    //  positionChild(
    //    1,
    //    Offset(screenWidth - firstSize.width, 0),
    //  );
    //}

    if (hasChild(2)) {
      secondSize = layoutChild(
        2,
        BoxConstraints(),
      );

      positionChild(
        2,
        Offset(0, screenHeight * 0.6 - 58),
      );
    }

    if (hasChild(3)) {
      thirdSize = layoutChild(
        3,
        BoxConstraints(),
      );

      positionChild(
        3,
        Offset(screenWidth * 0.5, screenHeight * 0.6 - 58),
      );
    }
  }

  @override
  bool shouldRelayout(_MyDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class DashBoardDesktop extends StatefulWidget {
  DashBoardDesktop(double this.width);
  double width;
  @override
  State<DashBoardDesktop> createState() => _DashBoardDesktopState();
}

class _DashBoardDesktopState extends State<DashBoardDesktop>
    with AutomaticKeepAliveClientMixin<DashBoardDesktop> {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSetup setup = Provider.of<AppSetup>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<dynamic>(
      //future: getRaceTrack(race: race),
      future: getCurrentUserIdInt(),
      builder: (context, snapshot) {
        return setup.isOverview
            ? Overview(widget.width)
            : CustomMultiChildLayout(
                delegate: _MyDelegate(
                    position: Offset.zero,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth),
                children: [
                  //LayoutId(
                  //  id: 1,
                  //  child: Container(
                  //    height: screenHeight * 0.5,
                  //    width: screenWidth * 0.8,
                  //    child: DriversDataWidget(),
                  //  ),
                  //),
                  LayoutId(
                    id: 2,
                    child: (snapshot.data == null)
                        ? CircularProgressIndicator()
                        : Container(
                            //color: Colors.red,
                            height: screenHeight * 0.4,
                            width: screenWidth * 0.35,
                            child: Container()
                            //Image.network(
                            //  snapshot.data!,
                            //  fit: BoxFit.contain,
                            //),
                            ),
                  ),
                  LayoutId(
                    id: 3,
                    child: Container(
                        height: 300,
                        width: 450,
                        child: Container() //Overview(),
                        ),
                  ),
                ],
              );
      },
    );
  }
}


  
  // return Center(child: DriversDataWidget());

  // return Container(
  //   padding: EdgeInsets.all(20),
  //   child: Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisSize: MainAxisSize.max,
  //     children: [
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           Visibility(
  //             visible: showWeather,
  //             child: WeatherWidget(),
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  // );

