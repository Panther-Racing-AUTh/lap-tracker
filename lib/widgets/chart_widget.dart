import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/telemetry.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:flutter_complete_guide/supabase/data_functions.dart';
import 'package:flutter_complete_guide/widgets/graph.dart';
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
  List<List<Data>> dataList = [];
  refresh(newfinalList) {
    finalList = newfinalList;
  }

  void trigger() async {
    AppSetup a = Provider.of<AppSetup>(context, listen: false);
    dataList = await getDataFromList(a.chartList.skip(2).toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppSetup a = Provider.of<AppSetup>(context, listen: false);

    finalList = a.chartList;
    if (a.mainScreenDesktopIndex == 3 && a.chatId != -1) trigger();
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
              TextButton(
                  onPressed: () async {
                    dataList =
                        await getDataFromList(a.chartList.skip(2).toList());
                    setState(() {});
                  },
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 20),
                  )),
              if (finalList.length > 1)
                TextButton(
                  onPressed: () async {
                    final channels =
                        await getAllChannelsForUser(id: a.supabase_id);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Choose Group:'),
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: channels.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: Text((index + 1).toString()),
                                    title: Text(channels[index]['name']),
                                    onTap: () {
                                      sendChart(
                                          list: finalList,
                                          id: a.supabase_id,
                                          channel_id: channels[index]['id']);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Send to Chat',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Graph(
              list: dataList,
              isMessage: false,
              showDetails: true,
            ),
          ),
        ],
      ),
    );
  }
}
