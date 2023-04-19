import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/telemetry.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:flutter_complete_guide/supabase/data_functions.dart';
import 'package:flutter_complete_guide/widgets/graph.dart';
import 'package:provider/provider.dart';
import '../providers/app_setup.dart';
import './checked_boxes_widget.dart';

class EchartsPage extends StatefulWidget {
  EchartsPage({Key? key}) : super(key: key);

  @override
  State<EchartsPage> createState() => _EchartsPageState();
}

class _EchartsPageState extends State<EchartsPage> {
  //Initializing the lists
  List<dynamic> finalList = [];
  List<List<Data>> dataList = [];
  bool triggered = false;

  void refresh(newfinalList) {
    finalList = newfinalList;
  }

//TODO This is for opening the chart page on the chat maintaning the data (ERROR)
  void trigger() async {
    AppSetup setup = Provider.of<AppSetup>(context, listen: false);
    dataList = await getDataFromList(setup.chartList.skip(2).toList());
    triggered = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppSetup setup = Provider.of<AppSetup>(context, listen: false);

    finalList = setup.chartList;
    //check if user was redirected from chat or not
    if (setup.mainScreenDesktopIndex == 2 && setup.chatId != -1 && !triggered)
      trigger();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              //Check boxes for the sensor data
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: 250,
                child: CheckedBoxWidget(
                  setFinalList: refresh,
                ),
              ),

              //Fetch the sensor data available from supabase
              TextButton(
                  onPressed: () async {
                    dataList =
                        await getDataFromList(setup.chartList.skip(2).toList());
                    setState(() {});
                  },
                  child: Text(
                    'Fetch Data',
                    style: TextStyle(fontSize: 20),
                  )),

              //When you press the SEND TO CHAT
              if (finalList.length > 1)
                TextButton(
                  onPressed: () async {
                    final channels =
                        await getAllChannelsForUser(id: setup.supabase_id);
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
                                          id: setup.supabase_id,
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
                ), //center graph button
              TextButton(
                child: Text(
                  'Center Graph',
                  style: TextStyle(fontSize: 19),
                ),
                onPressed: () => setState(() {
                  setup.timeConstraints[0] = null;
                  setup.timeConstraints[1] = null;
                }),
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
