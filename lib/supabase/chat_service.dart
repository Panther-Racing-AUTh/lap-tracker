import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/supabase/profile_functions.dart';
import 'package:universal_io/io.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List> getAllUsers() async {
  final users =
      await supabase.from('users').select('id, uuid, full_name, role');

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
    {required int channel_id, required List allChannelUsersList}) {
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
            id,
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
