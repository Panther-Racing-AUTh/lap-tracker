import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/weather_widget.dart';

Widget DashBoardDesktop({required screenHeight}) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              WeatherWidget(),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.866,
          )
        ],
      ),
    ),
  );
}
