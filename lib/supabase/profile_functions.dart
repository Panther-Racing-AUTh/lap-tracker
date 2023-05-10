import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_complete_guide/models/person.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List> getUserProfile({required int id}) async {
  final data = await supabase
      .from('users')
      .select('full_name, role, about, department')
      .eq('id', id)
      .single();
  var image = supabase.storage
      .from('users')
      .getPublicUrl(supabase.auth.currentUser!.id + '.jpeg');
  print(await validateImage(image));
  final dept_image = supabase.storage
      .from('departments')
      .getPublicUrl(data['department'] + '.jpeg');

  final admins = await supabase
      .from('user_roles')
      .select('''admin_name: user_id ( full_name )''').eq('role_id', 1);

  return [
    admins,
    Person(
      name: data['full_name'],
      role: data['role'],
      about: data['about'],
      department: data['department'],
      image: await validateImage(image)
          ? image
          : image.split('users/').first + 'users/default.webp',
      department_image: dept_image,
    )
  ];
}

Future<void> saveProfile({required int id, required Person p}) async {
  await supabase.from('users').update(Person.toMap(p)).match({
    'id': id,
  });
}

Future<bool> validateImage(String imageUrl) async {
  http.Response res;
  try {
    res = await http.get(Uri.parse(imageUrl));
  } catch (e) {
    return false;
  }

  if (res.statusCode != 200) return false;
  Map<String, dynamic> data = res.headers;
  return checkIfImage(data['content-type']);
}

bool checkIfImage(String param) {
  if (param == 'image/jpeg' ||
      param == 'image/png' ||
      param == 'image/gif' ||
      param == 'image/webp') {
    return true;
  }
  return false;
}
