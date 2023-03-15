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
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSetup a = Provider.of<AppSetup>(context);
    finalList = a.chartList;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: 250,
                child: CheckedBoxWidget(
                  setFinalList: refresh,
                ),
              ),
              if (finalList.length > 3)
                TextButton(
                    onPressed: () =>
                        sendChart(list: finalList, id: a.supabase_id),
                    child: Text(
                      'Send to Chat',
                      style: TextStyle(fontSize: 20),
                    )),
            ],
          ),
          if (finalList.length > 3)
            EchartsWidget(
              finalList: a.chartList,
            ),
        ],
      ),
    );
  }
}
