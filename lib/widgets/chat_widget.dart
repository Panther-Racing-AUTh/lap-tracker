import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/message.dart';
import '../supabase/chat_service.dart';
import 'chat_bubble.dart';

class ChatWidget extends StatefulWidget {
  @override
  State<ChatWidget> createState() => _ChatWidgetState();

  ChatWidget() {
    print('ChatWidget constructed');
  }
}

class _ChatWidgetState extends State<ChatWidget> {
  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();

  Future<void> _submit() async {
    final text = _msgController.text;

    if (text.isEmpty) {
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await saveMessage(text);

      _msgController.text = '';
    }
  }

  @override
  void dispose() {
    print('chat widget disposed!');
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: getMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            (Supabase.instance.client.auth.currentUser != null)) {
          final messages = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return (message.isMine)
                          ? ChatBubble(
                              message: message,
                              context: context,
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundImage:
                                        NetworkImage(message.userFromImage),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              message.userFromName,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16.0),
                                            ),
                                          ],
                                        ),
                                        ChatBubble(
                                          message: message,
                                          context: context,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            message.createAt.toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _msgController,
                        decoration: InputDecoration(
                            labelText: 'Message',
                            suffixIcon: IconButton(
                              onPressed: () => _submit(),
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.grey,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0)
              ],
            ),
          );
        } else if (Supabase.instance.client.auth.currentUser == null) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Text(
                  'Sign In to see the Chat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
