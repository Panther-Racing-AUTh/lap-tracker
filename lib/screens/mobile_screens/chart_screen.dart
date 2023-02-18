import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import '../../widgets/main_appbar.dart';

class ChartScreen extends StatelessWidget {
  //static const String routeName = '/chart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: chart,
        context: context,
      ),
      body: Center(
        child: Text('Chart Screen'),
      ),
    );
  }
}
