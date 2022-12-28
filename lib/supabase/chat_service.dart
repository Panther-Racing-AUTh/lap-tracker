// ignore_for_file: deprecated_member_use

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
              .from('profiles')
              .getPublicUrl(item['user_from'] + '.jpeg');
          return Message.fromJson(
            item,
            getCurrentUserId(),
            senderImage,
          );
        }).toList(),
      );
}

Future<void> saveMessage(String content) async {
  final sender = await supabase
      .from('profiles')
      .select('name')
      .eq('id', getCurrentUserId())
      .single();

  final message = Message.create(
    content: content,
    userFrom: getCurrentUserId(),
    userFromName: sender['name'],
  );
  await supabase.from('messages').insert(message.toMap());
}

Future<void> updateMessages() async {
  final messages =
      await supabase.from('messages').select('user_from, user_from_name');
  final profiles = await supabase.from('profiles').select('id, name');

  for (int i = 0; i < messages.length; i++) {
    //final currentMessage = messages[i];
    for (int j = 0; j < profiles.length; j++) {
      //final currentProfile = profiles[j];
      if (messages[i]['user_from'] == profiles[j]['id']) {
        if (messages[i]['user_from_name'] != profiles[j]['name']) {
          supabase.from('messages').update({
            'user_from_name': profiles[j]['name'],
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
