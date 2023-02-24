import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:provider/provider.dart';
import '../providers/app_setup.dart';
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
      //print('final list:' + finalList.toString());
    });
    // print('The final list2 is ${finalList}');
  }

  @override
  Widget build(BuildContext context) {
    AppSetup a = Provider.of<AppSetup>(context);
    finalList = a.chartList;
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 500,
                width: 250,
                child: CheckedBoxWidget(
                  setFinalList: refresh,
                ),
              ),
              if (finalList.length != 0)
                TextButton(
                    onPressed: () => sendChart(finalList),
                    child: Text(
                      'Send to Chat',
                      style: TextStyle(fontSize: 20),
                    )),
            ],
          ),
          if (finalList.length != 0)
            EchartsWidget(
              finalList: finalList,
            ),
        ],
      ),
    );
  }
}
