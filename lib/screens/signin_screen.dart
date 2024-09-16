import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/weather_widget.dart';
import '../widgets/login.dart';

class SigninScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Container(
            child: Login(),
            // child: WeatherWidget(screenWidth: 1000),
            height: MediaQuery.of(context).size.height * 0.88,
          ),
        ],
      ),
    );
  }
}
