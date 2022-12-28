import 'package:flutter_complete_guide/models/person.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Person> getUserProfile({required String uuid}) async {
  final data = await supabase
      .from('profiles')
      .select('name, role, about, department')
      .eq('id', uuid)
      .single();
  final image = supabase.storage
      .from('profiles')
      .getPublicUrl(supabase.auth.currentUser!.id + '.jpeg');
  final dept_image = supabase.storage
      .from('departments')
      .getPublicUrl(data['department'] + '.jpeg');

  return Person(
    name: data['name'],
    role: data['role'],
    about: data['about'],
    department: data['department'],
    image: image,
    department_image: dept_image,
  );
}

Future<void> saveProfile(Person p) async {
  await supabase.from('profiles').update(Person.toMap(p)).match({
    'id': supabase.auth.currentUser!.id,
  });
}

Future<Person> getMessageProfile({required String uuid}) async {
  final data = await supabase
      .from('profiles')
      .select('name, role, about, department')
      .eq('id', uuid)
      .single();
  final image = supabase.storage
      .from('profiles')
      .getPublicUrl(supabase.auth.currentUser!.id + '.jpeg');
  return Person(
    name: data['name'],
    role: data['role'],
    about: data['about'],
    department: data['department'],
    image: image,
  );
}
