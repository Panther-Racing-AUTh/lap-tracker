import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:provider/provider.dart';

import '../providers/app_setup.dart';
import '../supabase/chat_service.dart';

class ChatLandingPage extends StatefulWidget {
  const ChatLandingPage({super.key});

  @override
  State<ChatLandingPage> createState() => _ChatLandingPageState();
}

class _ChatLandingPageState extends State<ChatLandingPage> {
  late Future<List> dataFuture;

  @override
  void initState() {
    super.initState();
    //if (supabase.auth.currentSession != null)
    dataFuture = getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    AppSetup setup = Provider.of<AppSetup>(context);

    return (setup.chatId == '0')
        ? FutureBuilder<List>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List users = snapshot.data!;
                List listWithGroupChat = [
                  {
                    'id': '1',
                    'full_name': 'Group Chat',
                    'profile_image':
                        'https://png.pngtree.com/png-vector/20190330/ourmid/pngtree-vector-leader-of-group-icon-png-image_894944.jpg',
                    'role': ''
                  },
                  ...users
                ];
                return ListView.builder(
                  itemCount: users.length + 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            setup.chatId =
                                listWithGroupChat[index]['id'].toString();
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
                                      radius: 35.0,
                                      backgroundImage: NetworkImage(
                                          listWithGroupChat[index]
                                              ['profile_image']),
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
                                          Text(
                                              listWithGroupChat[index]
                                                  ['full_name'],
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          (index != 0)
                                              ? Text(
                                                  listWithGroupChat[index]
                                                      ['role'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ))
                                              : Container(),
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
        : ChatWidget();
  }
}
