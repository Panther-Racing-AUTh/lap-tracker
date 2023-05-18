import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/queries.dart';
import 'package:flutter_complete_guide/widgets/checked_boxes_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as provider;
import '../../models/message.dart';
import '../names.dart';
import '../providers/app_setup.dart';
import '../supabase/chat_service.dart';
import 'chat_bubble.dart';

class ChatWidget extends StatefulWidget {
  ChatWidget(this.function);
  Function function;
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

List<dynamic> ChartList = [];
List<Message> messagesGlobal = [];
void passList(List l) {
  ChartList = l;
  print(ChartList);
}

class _ChatWidgetState extends State<ChatWidget> {
  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

/*
  Future<void> pickChart({required BuildContext c, required int id}) async {
    showDialog(
      context: c,
      builder: (ctx) => AlertDialog(
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                    child: CheckedBoxWidget(
                  setFinalList: passList,
                )),
              ),
              IconButton(
                onPressed: () {
                  print(ChartList);
                  sendChart(list: ChartList, id: id);
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
*/
//pick image function
  Future pickImage(
      {required bool isCamera, required int id, required int channelId}) async {
    try {
      final image = await ImagePicker().pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (image == null) return;

      saveImage(image: image, id: id, channelId: channelId);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

//send message function
  Future<void> _submit({required int userId, required int channelId}) async {
    final text = _msgController.text;

    if (text.isEmpty) {
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await saveMessage(content: text, userId: userId, channelId: channelId);

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
    print('built single chat ');
    AppSetup setup = provider.Provider.of<AppSetup>(context);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.numpadEnter): () {
          _submit(userId: setup.supabase_id, channelId: setup.chatId);
        }
      },
      child: Focus(
        autofocus: true,
        child: Subscription(
          options: SubscriptionOptions(
            document: gql(getMessagesForChannel),
            variables: {'channelId': setup.chatId},
          ),
          onSubscriptionResult: (subscriptionResult, client) {
            print(subscriptionResult);
            print(client);
          },
          builder: (result) {
            print('inserted builder function');
            print(result);
            if (result.hasException) {
              print('exception');
              print(result.exception);
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              print('loading');
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            print('tried to build widget');
            List<Message> messages = [];
            for (var message in result.data!['message'])
              messages.add(
                Message.fromJson(
                  message,
                  setup.supabase_id == message['user_id'],
                  'https://pwqrcfdxmgfavontopyn.supabase.co/storage/v1/object/public/users/40a8216a-d486-42c5-bf96-85e8bf5664d6.jpeg',
                ),
              );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 45,
                            child: IconButton(
                              iconSize: 25,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                setup.setChatId(-1);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              //add user to chat button
                              IconButton(
                                onPressed: (() {
                                  addUserToChat(
                                    context: context,
                                    channelId: setup.chatId,
                                  );
                                }),
                                icon: Icon(Icons.group_add_rounded),
                              ),
                              //show group users button
                              IconButton(
                                onPressed: (() {
                                  showChannelUsers(
                                      channelId: setup.chatId,
                                      context: context);
                                }),
                                icon: Icon(Icons.more_vert),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    //show messages
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return (message.isMine)
                            ? ChatBubble(
                                message: message,
                                context: context,
                                function: widget.function,
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
                                                '',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                          ChatBubble(
                                            message: message,
                                            context: context,
                                            function: widget.function,
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
                  ActionBar(userId: setup.supabase_id, channelId: setup.chatId),
                  const SizedBox(height: 20.0)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget ActionBar({required int userId, required int channelId}) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _msgController,
              onFieldSubmitted: (value) {
                _submit(userId: userId, channelId: channelId);
              },
              decoration: InputDecoration(
                  labelText: 'Message',
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          //pickChart(c: context, id: id);
                        },
                        icon: Icon(Icons.bar_chart),
                      ),
                      IconButton(
                        onPressed: () {
                          pickImage(
                              isCamera: true, id: userId, channelId: channelId);
                        },
                        icon: Icon(Icons.camera_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          pickImage(
                              isCamera: false,
                              id: userId,
                              channelId: channelId);
                        },
                        icon: Icon(Icons.image_outlined),
                      ),
                      IconButton(
                        onPressed: () =>
                            _submit(userId: userId, channelId: channelId),
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
