import 'package:flutter/material.dart';
import '../../widgets/main_appbar.dart';

class ChartScreen extends StatelessWidget {
  //static const String routeName = '/chart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: 'Chart',
        context: context,
      ),
      body: Center(
        child: Text('Chart Screen'),
      ),
    );
  }
}
