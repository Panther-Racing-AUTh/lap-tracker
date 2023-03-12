import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List> getUsersWithRoles() async {
  final users = await supabase
      .from('user_roles')
      .select('''user:user_id ( full_name, role, department ), role:role_id ( role ), created_at, last_modified''').order(
          'created_at');

  return users;
}
