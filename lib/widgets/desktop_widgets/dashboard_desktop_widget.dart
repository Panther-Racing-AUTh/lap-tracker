import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/supabase/select_race_track_functions.dart';
import 'package:flutter_complete_guide/widgets/drivers_grid.dart';

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
    late Size secondSize;
    late Size thirdSize;

    if (hasChild(1)) {
      secondSize = layoutChild(
        1,
        BoxConstraints(
          maxHeight: 400,
          maxWidth: 800,
        ),
      );

      positionChild(
        1,
        Offset(screenWidth - secondSize.width, 0),
      );
    }

    if (hasChild(2)) {
      thirdSize = layoutChild(
        2,
        BoxConstraints(
          minHeight: screenHeight - secondSize.height - 50,
          minWidth: screenWidth - secondSize.width,
          maxHeight: screenHeight - secondSize.height - 1,
          //maxWidth: screenWidth - secondSize.width,
        ),
      );

      positionChild(
        2,
        Offset(0, screenHeight / 2 - 100),
      );
    }
  }

  @override
  bool shouldRelayout(_MyDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

Widget DashBoardDesktop({
  required Race race,
  required bool showWeather,
  required bool showDriverBoard,
  required double screenHeight,
  required double screenWidth,
}) {
  return FutureBuilder<String>(
    future: getRaceTrack(race: race),
    builder: (context, snapshot) {
      return CustomMultiChildLayout(
        delegate: _MyDelegate(
            position: Offset.zero,
            screenHeight: screenHeight,
            screenWidth: screenWidth),
        children: [
          LayoutId(
            id: 1,
            child: DriversDataWidget(),
          ),
          LayoutId(
            id: 2,
            child: Image.network(
              snapshot.data!,
              fit: BoxFit.contain,
            ),
          ),
        ],
      );
    },
  );

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
}
