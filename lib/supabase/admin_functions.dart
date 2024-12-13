import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List> getUsersWithRoles() async {
  List users = await supabase
      .from('user_roles')
      .select('''primary_id: id, user:user_id ( id, full_name, role, department, active ), role:role_id ( role ), created_at, last_modified''').order(
          'created_at');

  final roles = await supabase.from('roles').select('id, role');
  users.removeWhere((user) => user['user']['active'] != true);
  return [roles, users];
}

Future<void> updateUserRoles(List<Map> users) async {
  await supabase.from('user_roles').upsert(users);
}
