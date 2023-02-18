import 'package:flutter/material.dart';
import '../../widgets/main_appbar.dart';
import 'package:flutter_complete_guide/names.dart';

class PantherScreen extends StatelessWidget {
  //static const String routeName = '/panther';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: panther_screen_appbar,
        context: context,
      ),
      body: Center(
        child: Text(panther_screen_body),
      ),
    );
  }
}
