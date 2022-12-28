//import 'package:chat_app/mark_as_read.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final BuildContext context;
  const ChatBubble({Key? key, required this.message, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          maxWidth: MediaQuery.of(context).size.width * 0.5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: message.isMine ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message.content,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
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
