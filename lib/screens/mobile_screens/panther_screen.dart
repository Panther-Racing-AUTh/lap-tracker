import 'package:flutter/material.dart';
import '../../widgets/main_appbar.dart';

class PantherScreen extends StatelessWidget {
  //static const String routeName = '/panther';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: 'Panther Racing Auth Team',
        context: context,
      ),
      body: Center(
        child: Text('Panther Racing Auth Screen'),
      ),
    );
  }
}
