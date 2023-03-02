import 'dart:convert';

import 'package:universal_io/io.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Stream<List<Message>> getMessages() {
  updateMessages();
  return supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .map(
        (maps) => maps.map((item) {
          final senderImage = supabase.storage
              .from('users')
              .getPublicUrl(item['user_from'] + '.jpeg');

          return Message.fromJson(
            item,
            getCurrentUserId(),
            senderImage,
          );
        }).toList(),
      );
}

//TODO: fix handling of image upload
Future<void> saveImage(XFile image) async {
  final sender = await supabase
      .from('users')
      .select('full_name')
      .eq('id', getCurrentUserId())
      .single();

  supabase.storage.from('message-images').uploadBinary(
      '${getCurrentUserId()}/${image.name}',
      await File(image.path).readAsBytes(),
      fileOptions: FileOptions(contentType: image.mimeType));

  final message = Message.createImage(
      content: '${getCurrentUserId()}/${image.name}',
      userFrom: getCurrentUserId(),
      userFromName: sender['full_name']);
  await supabase.from('messages').insert({message.toMap()});
}

Future<void> saveMessage(String content) async {
  final sender = await supabase
      .from('users')
      .select('full_name')
      .eq('id', getCurrentUserId())
      .single();

  final message = Message.createText(
    content: content,
    userFrom: getCurrentUserId(),
    userFromName: sender['full_name'],
  );
  await supabase.from('messages').insert(message.toMap());
}

Future<void> updateMessages() async {
  final messages =
      await supabase.from('messages').select('user_from, user_from_name');
  final profiles = await supabase.from('users').select('id, full_name');

  for (int i = 0; i < messages.length; i++) {
    //final currentMessage = messages[i];
    for (int j = 0; j < profiles.length; j++) {
      //final currentProfile = profiles[j];
      if (messages[i]['user_from'] == profiles[j]['id']) {
        if (messages[i]['user_from_name'] != profiles[j]['full_name']) {
          supabase.from('messages').update({
            'user_from_name': profiles[j]['full_name'],
          }).match({
            'user_from': profiles[j]['id'],
          }).execute();
        }
      }
    }
  }
}

Future<void> markAsRead(String messageId) async {
  await supabase
      .from('messages')
      .update({'mark_as_read': true}).eq('id', messageId);
}

bool isAuthentificated() => supabase.auth.currentUser != null;

String getCurrentUserId() =>
    isAuthentificated() ? supabase.auth.currentUser!.id : '';

Future<void> sendChart(List<dynamic> l) async {
  final sender = await supabase
      .from('users')
      .select('full_name')
      .eq('id', getCurrentUserId())
      .single();
  print(l.toString());
  final message = Message.createChart(
    content: l.toString(),
    userFrom: getCurrentUserId(),
    userFromName: sender['full_name'],
  );
  await supabase.from('messages').insert(message.toMap());
}
