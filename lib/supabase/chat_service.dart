import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/supabase/profile_functions.dart';
import 'package:universal_io/io.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as p;

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
  List allUsers = [];
  List allUsersWithImage = [];
  final data = await supabase
      .from('channel_users')
      .select(''' user_id: user_id(id, full_name, role, department, uuid) ''');
  data.forEach((element) {
    allUsers.add(element['user_id']);
  });

  for (var element in allUsers) {
    var image = supabase.storage.from('users').getPublicUrl(
        (element['uuid'] == null) ? '' : element['uuid'] + '.jpeg');
    element['profile_image'] = await validateImage(image)
        ? image
        : image.split('users/').first + 'users/default.webp';
    allUsersWithImage.add(element);
  }
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

Future addUserToChat(
    {required BuildContext context,
    required int channelId,
    required List allUsersOfChannel}) async {
  List selectedUsers = [];
  List<bool> selectedUsersValues = [];

  showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder<List>(
        future: getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List allUsers = snapshot.data!;
            allUsers.forEach((element) {
              bool exists = false;
              for (int j = 0; j < allUsersOfChannel.length; j++) {
                if (element['id'] == allUsersOfChannel[j]['id']) {
                  exists = true;
                }
              }
              if (!exists) selectedUsers.add(element);
            });
            for (int i = 0; i < selectedUsers.length; i++) {
              selectedUsersValues.add(false);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  child: AlertDialog(
                    title: Text('Add User'),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectedUsers.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      selectedUsers[index]['profile_image']),
                                ),
                                SizedBox(width: 15),
                                Text(selectedUsers[index]['full_name']),
                                SizedBox(width: 15),
                                Text(selectedUsers[index]['department']),
                                SizedBox(width: 15),
                                Text(selectedUsers[index]['role'])
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: selectedUsersValues[index],
                            onChanged: (value) {
                              setState(
                                () {
                                  selectedUsersValues[index] =
                                      !selectedUsersValues[index];
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
                      TextButton(
                        onPressed: () async {
                          for (int i = 0; i < selectedUsersValues.length; i++) {
                            if (selectedUsersValues[i])
                              await supabase.from('channel_users').insert({
                                'user_id': selectedUsers[i]['id'],
                                'channel_id': channelId
                              });
                          }

                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
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

void showChannelUsers({required BuildContext context, required int channelId}) {
  showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder(
        future: getAllUsersFromChannel(channelId: channelId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List channelUsers = snapshot.data as List;
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
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(controller: channelName)),
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
                        child: Text('Cancel'),
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
                        child: Text('OK'),
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
