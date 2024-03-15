import 'package:flutter/material.dart';
import '../../widgets/main_appbar.dart';
import 'package:flutter_complete_guide/names.dart';

class CalendarScreen extends StatelessWidget {
  //static const String routeName = '/panther';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: 'Calendar',
        context: context,
      ),
      body: Center(
        child: //edw bazeis to widget
            Container(),
      ),
    );
  }
}
