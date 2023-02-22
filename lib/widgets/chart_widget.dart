import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:quiver/iterables.dart';
import 'package:quiver/strings.dart';
import './checked_boxes_widget.dart';
import 'echarts_widget.dart';

class EchartsPage extends StatefulWidget {
  EchartsPage({Key? key}) : super(key: key);

  @override
  State<EchartsPage> createState() => _EchartsPageState();
}

class _EchartsPageState extends State<EchartsPage> {
  List<dynamic> finalList = [];

  refresh(newfinalList) {
    setState(() {
      finalList = newfinalList;
    });
    print('The final list2 is ${finalList}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 500,
            width: 250,
            child: CheckedBoxWidget(
              setFinalList: refresh,
            ),
          ),
          if (finalList.length != 0) EchartsWidget(),
        ],
      ),
    );
  }
}
