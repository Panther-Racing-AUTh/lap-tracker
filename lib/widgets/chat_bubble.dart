//import 'package:chat_app/mark_as_read.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/echarts_widget.dart';
import 'package:flutter_complete_guide/widgets/graph.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../models/telemetry.dart';
import '../providers/app_setup.dart';
import '../supabase/data_functions.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final BuildContext context;
  final Function function;
  const ChatBubble({
    Key? key,
    required this.message,
    required this.context,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = (MediaQuery.of(context).size.width < 600)
        ? MediaQuery.of(context).size.width * 0.8
        : MediaQuery.of(context).size.width * 0.5;

    AppSetup setup = Provider.of<AppSetup>(context);

    var chatContents = [
      const SizedBox(width: 12.0),
      Column(
        crossAxisAlignment: (message.isMine)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: (message.isMine)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: width),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: (message.type == 'text')
                            ? message.isMine
                                ? Theme.of(context).primaryColor
                                : Colors.grey
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: (message.type == 'text')
                          ? Text(
                              message.content,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            )
                          : GestureDetector(
                              child: Stack(
                                children: [
                                  FutureBuilder(
                                    future: getDataFromList(
                                        chartStringToList(message.content)
                                            .skip(2)
                                            .toList()),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState !=
                                              ConnectionState.done ||
                                          !snapshot.hasData)
                                        return Center(
                                            child: CircularProgressIndicator());
                                      dynamic dataList;
                                      dataList = snapshot.data;
                                      return Graph(
                                        isMessage: true,
                                        list: dataList,
                                        showDetails: false,
                                      );
                                    },
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    width: width,
                                    height: 300,
                                  ),
                                ],
                              ),
                              onLongPress: () => showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        actions: [
                                          Card(
                                            child: ListTile(
                                                title:
                                                    Text('View in Fullscreen'),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                      context: ctx,
                                                      builder: (c) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.9,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            child:
                                                                FutureBuilder(
                                                              future: getDataFromList(
                                                                  chartStringToList(
                                                                          message
                                                                              .content)
                                                                      .skip(2)
                                                                      .toList()),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot.connectionState !=
                                                                        ConnectionState
                                                                            .done ||
                                                                    !snapshot
                                                                        .hasData)
                                                                  return Center(
                                                                      child:
                                                                          CircularProgressIndicator());
                                                                dynamic
                                                                    dataList;
                                                                dataList =
                                                                    snapshot
                                                                        .data;
                                                                return Graph(
                                                                  isMessage:
                                                                      true,
                                                                  list:
                                                                      dataList,
                                                                  showDetails:
                                                                      true,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }),
                                          ),
                                          Card(
                                            child: ListTile(
                                              title: Text(
                                                  'Open in \'Chart\' page'),
                                              onTap: () {
                                                function();
                                                setup.setListFull(
                                                    chartStringToList(
                                                        message.content));
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          )
                                        ],
                                      )),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
          if (message.isMine)
            Container(
              padding: EdgeInsets.only(left: 47),
              child: Text(message.createAt.toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
          const SizedBox(width: 60),
        ],
      ),
    ];

    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return Padding(
      padding:
          message.isMine ? EdgeInsets.symmetric(vertical: 18) : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

List<dynamic> chartStringToList(String t) {
  List<dynamic> l = [], u = [];
  u = t.replaceFirst('[', '').replaceFirst(']', '').split(',').toList();

  l.add(DateTime.parse(u[0]));
  l.add(u[1].replaceFirst(' ', ''));

  for (int i = 2; i < u.length; i++) {
    l.add(u[i].replaceFirst(' ', ''));
  }
  return l;
}
