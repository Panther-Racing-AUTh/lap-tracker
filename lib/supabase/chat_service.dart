import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/supabase/profile_functions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as p;

import '../models/person.dart';
import '../queries.dart';

final supabase = Supabase.instance.client;

Future<List> getAllUsers() async {
  final users = await supabase
      .from('users')
      .select('id, uuid, full_name, role, department');

  for (var element in users) {
    var image = supabase.storage.from('users').getPublicUrl(
        (element['uuid'] == null) ? '' : element['uuid'] + '.jpeg');
    element['profile_image'] = await validateImage(image)
        ? image
        : image.split('users/').first + 'users/default.webp';
  }
  return users;
}

Future<List> getAllChannelsForUser({required int id}) async {
  List<int> channelList = [];
  final allChannelIds = await supabase
      .from('channel_users')
      .select('channel_id')
      .eq('user_id', id);
  allChannelIds.forEach((element) {
    channelList.add(element['channel_id']);
  });
  final allChannels =
      await supabase.from('channel').select().in_('id', channelList);
  return allChannels;
}

Stream<List<Message>> getMessages(
    {required int channel_id,
    required List allChannelUsersList,
    required currentUserId}) {
  return supabase
      .from('message')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .eq('channel_id', channel_id)
      .map(
        (maps) => maps.map((item) {
          late String image;
          late int id;

          for (var element in allChannelUsersList) {
            if (item['user_id'] == element['id']) {
              id = element['id'];
              image = element['profile_image'];
              break;
            }
          }
          return Message.fromJson(
            item,
            id == currentUserId,
            image,
          );
        }).toList(),
      );
}

Future getAllUsersFromChannel({required int channelId}) async {
  print('getAllUsersFromChannel function called');
  List allUsers = [];
  List allUsersWithImage = [];
  final data = await supabase
      .from('channel_users')
      .select(''' user_id: user_id(id, full_name, role, department, uuid) ''').eq(
          'channel_id', channelId);
  data.forEach((element) {
    allUsers.add(element['user_id']);
  });
  print(allUsers);
  print(allUsers.length);
  for (var element in allUsers) {
    var image = supabase.storage.from('users').getPublicUrl(
        (element['uuid'] == null) ? '' : element['uuid'] + '.jpeg');
    element['profile_image'] = await validateImage(image)
        ? image
        : image.split('users/').first + 'users/default.webp';
    allUsersWithImage.add(element);
  }
  print(allUsersWithImage);
  print(allUsersWithImage.length);
  print('ended function getAllUsersFromChannel');
  return allUsersWithImage;
}

//TODO: fix handling of image upload
Future<void> saveImage(
    {required XFile image, required int id, required int channelId}) async {
  final sender =
      await supabase.from('users').select('full_name').eq('id', id).single();

  supabase.storage.from('message-images').uploadBinary(
      '${id}/${image.name}', await File(image.path).readAsBytes(),
      fileOptions: FileOptions(contentType: image.mimeType));

  final message = Message.createImage(
    content: '${id}/${image.name}',
    userFromId: id,
    channelId: channelId,
  );
  await supabase.from('messages').insert({message.toMap()});
}

Future<void> saveMessage(
    {required String content,
    required int userId,
    required int channelId}) async {
  final message = Message.createText(
    content: content,
    userFromId: userId,
    channelId: channelId,
  );
  await supabase.from('message').insert(message.toMap());
}

Future<void> sendChart(
    {required List<dynamic> list,
    required int id,
    required int channel_id}) async {
  final sender =
      await supabase.from('users').select('full_name').eq('id', id).single();
  final message = Message.createChart(
      content: list.toString(), userFromId: id, channelId: channel_id);
  await supabase.from('message').insert(message.toMap());
}

Future addUserToChat({
  required BuildContext context,
  required int channelId,
}) async {
  List<int> idsOfPeopleToBeAdded = [];
  bool allUsersAreOnChat = false;
  print(channelId);
  showDialog(
    context: context,
    builder: (context) {
      return Query(
        options: QueryOptions(
          document: gql(getUsersNotOnChannel),
          variables: {"channelId": channelId},
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          print('pressed button to see users not on chat');
          print('channelId = ' + channelId.toString());
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Person> allUsersNotOnChat = [];
          print(result.data);
          for (var user in result.data!['users'])
            allUsersNotOnChat.add(Person.fromJson(user));
          allUsersAreOnChat = allUsersNotOnChat.isEmpty;
          print(allUsersNotOnChat);
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                child: AlertDialog(
                  title: Text('Add User'),
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: (allUsersAreOnChat)
                        ? Text('There are no more users!')
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: allUsersNotOnChat.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundImage: NetworkImage(
                                          allUsersNotOnChat[index].image),
                                    ),
                                    SizedBox(width: 15),
                                    Text(allUsersNotOnChat[index].name),
                                    SizedBox(width: 15),
                                    Text(allUsersNotOnChat[index].department),
                                    SizedBox(width: 15),
                                    Text(allUsersNotOnChat[index].role)
                                  ],
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: idsOfPeopleToBeAdded
                                    .contains(allUsersNotOnChat[index].id),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      if (idsOfPeopleToBeAdded.contains(
                                          allUsersNotOnChat[index].id))
                                        idsOfPeopleToBeAdded.remove(
                                            allUsersNotOnChat[index].id);
                                      else
                                        idsOfPeopleToBeAdded
                                            .add(allUsersNotOnChat[index].id);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    Mutation(
                      options:
                          MutationOptions(document: gql(addUsersToChannel)),
                      builder: (RunMutation insert, result) {
                        return TextButton(
                          onPressed: allUsersAreOnChat
                              ? null
                              : () async {
                                  List<Map<String, int>> objects = [];
                                  for (var id in idsOfPeopleToBeAdded)
                                    objects.add({
                                      'channel_id': channelId,
                                      'user_id': id
                                    });

                                  insert({'objects': objects});
                                  Navigator.of(context).pop();
                                },
                          child: Text('OK'),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

void showChannelUsers({required BuildContext context, required int channelId}) {
  showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder(
        future: getAllUsersFromChannel(channelId: channelId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List channelUsers = snapshot.data as List;

            print(channelUsers);
            print(channelUsers.length);
            return Container(
              child: AlertDialog(
                title: Text('Users in this chat'),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: channelUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                  channelUsers[index]['profile_image']),
                            ),
                            SizedBox(width: 15),
                            Text(channelUsers[index]['full_name']),
                            SizedBox(width: 15),
                            Text(channelUsers[index]['department']),
                            SizedBox(width: 15),
                            Text(channelUsers[index]['role'])
                          ],
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    },
  );
}

Future addChat(
    {required BuildContext context,
    required int currentUserId,
    required Function refresh}) async {
  List<bool> allUsersValues = [];

  TextEditingController channelName = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder<List>(
        future: getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            List allUsers = snapshot.data!;

            allUsers.removeWhere(
              (element) => element['id'] == currentUserId,
            );
            print('snapshot.data');
            for (int i = 0; i < allUsers.length; i++) {
              allUsersValues.add(false);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  child: AlertDialog(
                    title: Text('Create group'),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              controller: channelName,
                              decoration: InputDecoration(
                                labelText: 'Group Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundImage: NetworkImage(
                                          allUsers[index]['profile_image']),
                                    ),
                                    SizedBox(width: 15),
                                    Text(allUsers[index]['full_name']),
                                    SizedBox(width: 15),
                                    Text(allUsers[index]['department']),
                                    SizedBox(width: 15),
                                    Text(allUsers[index]['role'])
                                  ],
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: allUsersValues[index],
                                onChanged: (value) {
                                  setState(
                                    () {
                                      allUsersValues[index] =
                                          !allUsersValues[index];
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel', style: TextStyle(fontSize: 20)),
                      ),
                      TextButton(
                        onPressed: () async {
                          final channelResponse = await supabase
                              .from('channel')
                              .insert({'name': channelName.text})
                              .select()
                              .order('created_at') as List;
                          final newChannelId = channelResponse.first['id'];
                          for (int i = 0; i < allUsersValues.length; i++) {
                            if (allUsersValues[i])
                              await supabase.from('channel_users').insert({
                                'user_id': allUsers[i]['id'],
                                'channel_id': newChannelId
                              });
                          }
                          await supabase.from('channel_users').insert({
                            'user_id': currentUserId,
                            'channel_id': newChannelId
                          });
                          Navigator.of(context).pop();
                          refresh();
                        },
                        child: Text('OK', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    },
  );
}
