import 'package:flutter/material.dart';
import '../chart_widget.dart';

class ChartDesktop extends StatelessWidget {
  const ChartDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: EchartsPage());
  }
}
