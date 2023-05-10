import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../models/channel.dart';
import '../providers/app_setup.dart';
import '../queries.dart';
import '../supabase/authentication_functions.dart';
import '../supabase/chat_service.dart';

class ChatLandingPage extends StatefulWidget {
  ChatLandingPage(Function this.function);
  Function function;
  @override
  State<ChatLandingPage> createState() => _ChatLandingPageState();
}

class _ChatLandingPageState extends State<ChatLandingPage>
    with AutomaticKeepAliveClientMixin<ChatLandingPage> {
  @override
  bool get wantKeepAlive => true;

  late Future<List> dataFuture;
  late List usersGlobal;
  @override
  void initState() {
    AppSetup setup = Provider.of<AppSetup>(context, listen: false);
    super.initState();
    //if (supabase.auth.currentSession != null)
    dataFuture = getAllChannelsForUser(id: setup.supabase_id);
  }

  Future<void> setStateFunction() async {
    setState(() {
      print('reached set state');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSetup setup = Provider.of<AppSetup>(context);
    //setup.chatId indicates the id from supabase of the chat shown. if it is -1, then no chat is selected and all the channels that the user is a part of are shown
    //check if no chat is selected, else show the contents
    return (setup.chatId == -1)
        ? Query(
            options: QueryOptions(
              document: gql(getAllChannelsForUserQuery),
              variables: {'id': setup.supabase_id},
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Channel> channels = [];
              for (var channel in result.data!['channel'])
                channels.add(Channel.fromJson(channel));

              //setup.allUsers = [...snapshot.data!];

              return RefreshIndicator(
                onRefresh: () => setStateFunction(),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ListView.builder(
                      itemCount: channels.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              //on tap of certain channel(group chat or direct message)
                              setup.allUsers = await getAllUsersFromChannel(
                                  channelId: channels[index].id);

                              setState(() {
                                setup.chatId = channels[index].id;
                              });
                            },
                            //ui of the chat, name and image
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, right: 20.0),
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 35.0,
                                          backgroundImage: NetworkImage(
                                            'https://png.pngtree.com/png-vector/20190330/ourmid/pngtree-vector-leader-of-group-icon-png-image_894944.jpg',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(channels[index].name,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ));
                      },
                    ),
                    //add chat button
                    Container(
                      padding: EdgeInsets.all(20),
                      child: FloatingActionButton(
                        child: Icon(Icons.add, size: 30),
                        onPressed: () => addChat(
                            context: context,
                            currentUserId: setup.supabase_id,
                            refresh: setStateFunction),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : ChatWidget(widget.function);
  }
}
