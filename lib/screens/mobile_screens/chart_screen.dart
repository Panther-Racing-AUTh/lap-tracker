import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/widgets/chart_widget.dart';
import '../../widgets/main_appbar.dart';

class ChartScreen extends StatelessWidget {
  //static const String routeName = '/chart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: chart_widget_motor_charts,
        context: context,
      ),
      body: Center(
        child: EchartsPage(),
      ),
    );
  }
}
