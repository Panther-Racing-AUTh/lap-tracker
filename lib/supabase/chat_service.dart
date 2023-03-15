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

Stream<List<Message>> getMessages({required int id, required List allUsers}) {
  return supabase
      .from('message')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .map(
        (maps) => maps.map((item) {
          final senderImage = allUsers.firstWhere(
              (element) => element['id'] == item['user_from'])['profile_image'];

          return Message.fromJson(
            item,
            id,
            senderImage,
          );
        }).toList(),
      );
}

//TODO: fix handling of image upload
Future<void> saveImage({required XFile image, required int id}) async {
  final sender =
      await supabase.from('users').select('full_name').eq('id', id).single();

  supabase.storage.from('message-images').uploadBinary(
      '${id}/${image.name}', await File(image.path).readAsBytes(),
      fileOptions: FileOptions(contentType: image.mimeType));

  final message = Message.createImage(
    content: '${id}/${image.name}',
    userFromId: id,
  );
  await supabase.from('messages').insert({message.toMap()});
}

Future<void> saveMessage({required String content, required int id}) async {
  final message = Message.createText(
    content: content,
    userFromId: id,
  );
  await supabase.from('message').insert(message.toMap());
}

Future<void> sendChart({required List<dynamic> list, required int id}) async {
  final sender =
      await supabase.from('users').select('full_name').eq('id', id).single();
  print(list.toString());
  final message = Message.createChart(
    content: list.toString(),
    userFromId: id,
  );
  await supabase.from('message').insert(message.toMap());
}
