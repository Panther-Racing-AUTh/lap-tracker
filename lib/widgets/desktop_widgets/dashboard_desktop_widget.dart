import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/drivers_grid.dart';
import 'package:flutter_complete_guide/widgets/weather_widget.dart';

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

    if (hasChild(2)) {
      secondSize = layoutChild(
        2,
        BoxConstraints(
          maxHeight: 400,
          maxWidth: 800,
        ),
      );

      positionChild(
        2,
        Offset(screenWidth - secondSize.width, 0),
      );
    }

    if (hasChild(3)) {
      thirdSize = layoutChild(
        3,
        BoxConstraints(
          minHeight: screenHeight - secondSize.height - 61,
          //minWidth: screenWidth - secondSize.width - 50,
          maxHeight: screenHeight - secondSize.height - 60,
          maxWidth: screenWidth - secondSize.width,
        ),
      );

      positionChild(
        3,
        Offset(screenWidth - thirdSize.width, secondSize.height),
      );
    }

    if (hasChild(1)) {
      firstSize = layoutChild(
        1,
        BoxConstraints(
          minHeight: 300,
          minWidth: 300,
        ),
      );

      positionChild(
        1,
        Offset(
            screenWidth - thirdSize.width - firstSize.width, secondSize.height),
      );
    }
  }

  @override
  bool shouldRelayout(_MyDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

Widget DashBoardDesktop({
  required bool showWeather,
  required bool showDriverBoard,
  required double screenHeight,
  required double screenWidth,
}) {
  return CustomMultiChildLayout(
    delegate: _MyDelegate(
        position: Offset.zero,
        screenHeight: screenHeight,
        screenWidth: screenWidth),
    children: [
      LayoutId(
        id: 1,
        child: WeatherWidget(),
      ),
      LayoutId(
        id: 2,
        child: DriversDataWidget(),
      ),
      LayoutId(
        id: 3,
        child: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Motorland_Arag%C3%B3n_FIA.svg/1200px-Motorland_Arag%C3%B3n_FIA.svg.png',
          fit: BoxFit.cover,
        ),
      ),
    ],
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
