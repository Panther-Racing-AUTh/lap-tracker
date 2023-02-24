//import 'package:chat_app/mark_as_read.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/echarts_widget.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../providers/app_setup.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final BuildContext context;
  const ChatBubble({Key? key, required this.message, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      constraints: BoxConstraints(
                          maxWidth: (MediaQuery.of(context).size.width < 600)
                              ? MediaQuery.of(context).size.width * 0.8
                              : MediaQuery.of(context).size.width * 0.5),
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
                                  //Edw tha paixtei mpalitsa na kses
                                  EchartsWidget(
                                    finalList: message.content
                                        .replaceFirst('[', '')
                                        .replaceFirst(']', '')
                                        .replaceAll(' ', '')
                                        .split(',')
                                        .toList(),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    width: 600,
                                    height: 310,
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
                                                            actions: [
                                                              EchartsWidget(
                                                                finalList: message
                                                                    .content
                                                                    .replaceFirst(
                                                                        '[', '')
                                                                    .replaceFirst(
                                                                        ']', '')
                                                                    .replaceAll(
                                                                        ' ', '')
                                                                    .split(',')
                                                                    .toList(),
                                                              )
                                                            ]);
                                                      });
                                                }),
                                          ),
                                          Card(
                                            child: ListTile(
                                              title: Text(
                                                  'Open in \'Chart\' page'),
                                              onTap: () {
                                                setup.setIndex(4);
                                                setup.setList(message.content
                                                    .replaceFirst('[', '')
                                                    .replaceFirst(']', '')
                                                    .replaceAll(' ', '')
                                                    .split(',')
                                                    .toList());
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
          //MarkAsRead(message: message),
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
