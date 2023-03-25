import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:provider/provider.dart';

import '../providers/app_setup.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSetup setup = Provider.of<AppSetup>(context);

    return (setup.chatId == -1)
        ? FutureBuilder<List>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List channels = [...snapshot.data!];
                //setup.allUsers = [...snapshot.data!];

                return ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () async {
                          setup.allUsers = await getAllUsersFromChannel(
                              channelId: channels[index]['id']);

                          setState(() {
                            setup.chatId = channels[index]['id'];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, right: 20.0),
                          padding: EdgeInsets.only(
                              left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(channels[index]['name'],
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
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          )
        : ChatWidget(widget.function);
  }
}
