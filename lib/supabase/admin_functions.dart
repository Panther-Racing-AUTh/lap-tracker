import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List> getUsersWithRoles() async {
  final users = await supabase
      .from('user_roles')
      .select('''primary_id: id, user:user_id ( id, full_name, role, department ), role:role_id ( role ), created_at, last_modified''').order(
          'created_at');
  final roles = await supabase.from('roles').select('id, role');
  return [roles, users];
}

Future<void> updateUserRoles(List<Map> users) async {
  await supabase.from('user_roles').upsert(users);
}
