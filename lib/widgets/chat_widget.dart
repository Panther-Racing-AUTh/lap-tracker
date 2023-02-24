import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/checked_boxes_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/message.dart';
import '../names.dart';
import '../supabase/chat_service.dart';
import 'chat_bubble.dart';

class ChatWidget extends StatefulWidget {
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

List<dynamic> ChartList = [];

void passList(List l) {
  ChartList = l;
}

class _ChatWidgetState extends State<ChatWidget> {
  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();

  Future<void> pickChart(BuildContext c) async {
    showDialog(
      context: c,
      builder: (ctx) => AlertDialog(
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                    child: CheckedBoxWidget(
                  setFinalList: passList,
                  noChartAttached: true,
                )),
              ),
              IconButton(
                onPressed: () {
                  sendChart(ChartList);
                  Navigator.of(ctx).pop();
                },
                icon: Icon(Icons.send),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future pickImage({required bool isCamera}) async {
    try {
      final image = await ImagePicker().pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (image == null) return;

      saveImage(image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

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
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.numpadEnter): () {
          _submit();
        }
      },
      child: Focus(
        autofocus: true,
        child: StreamBuilder<List<Message>>(
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                              padding:
                                                  EdgeInsets.only(left: 10),
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
                    ActionBar(),
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
                      sign_in_to_see_chat,
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
        ),
      ),
    );
  }

  Widget ActionBar() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _msgController,
              onFieldSubmitted: (value) {
                _submit();
              },
              decoration: InputDecoration(
                  labelText: 'Message',
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          pickChart(context);
                        },
                        icon: Icon(Icons.bar_chart),
                      ),
                      IconButton(
                        onPressed: () {
                          pickImage(isCamera: true);
                        },
                        icon: Icon(Icons.camera_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          pickImage(isCamera: false);
                        },
                        icon: Icon(Icons.image_outlined),
                      ),
                      IconButton(
                        onPressed: () => _submit(),
                        icon: const Icon(
                          Icons.send_rounded,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      );
}
