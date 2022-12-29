import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/settings.dart';
import '../../widgets/main_appbar.dart';

class SettingsScreen extends StatelessWidget {
  //static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: 'Settings',
        context: context,
      ),
      body: Settings(context),
    );
  }
}
