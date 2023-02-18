import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/widgets/desktop_widgets/data_desktop_widget.dart';
import '../../widgets/main_appbar.dart';

class DataScreen extends StatefulWidget {
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  //static const String routeName = '/data';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
          text: data,
          context: context,
        ),
        body: DataDesktopWidget());
  }
}
