import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../providers/app_setup.dart';
import '../providers/device.dart';
import '../widgets/signIn_alert_dialog.dart';
import 'package:provider/provider.dart' as p;

final supabase = Supabase.instance.client;

//checks if user exists in database

//insert user to database table
Future<void> insertUser({
  required String email,
  required String password,
  required String provider,
}) async {
  final user = await supabase
      .from('users')
      .update({'password': password, 'provider': provider})
      .eq('email', email)
      .select()
      .order('created_at');

  print('object');

  print(user);
  await supabase.from('user_roles').insert({
    'user_id': user[0]['id'],
    'role_id': 4,
  });
}

//login already existing user
Future<void> userLogin({
  required final String email,
  required final String password,
  required final bool signedUp,
  required final BuildContext context,
  required final bool userExists,
}) async {
  AppSetup a = p.Provider.of<AppSetup>(context, listen: false);
  DeviceManager device = p.Provider.of<DeviceManager>(context, listen: false);
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    await Future.value(a.setValuesAuto());
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed(device.getRoute());
  } on AuthException catch (error) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(error.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(cancel),
              ),
            ],
          );
        });
  }
}

//sign up non existing user- email confirmation is required
Future<void> userSignUp({
  required final String email,
  required final String password,
  required final bool signedUp,
  required final bool userExists,
  required final BuildContext context,
}) async {
  try {
    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': 'First Name'},
    );
    insertUser(email: email, provider: 'email', password: password);
    //User? user = response.user;

  } on AuthException catch (error) {
    showSignInAlertDialog(context: context, errorMessage: error.message);
  }
}

//sign in with OAuth
Future<void> signInWithOAuth(BuildContext context,
    {required Provider provider}) async {
  AppSetup a = p.Provider.of<AppSetup>(context, listen: false);
  DeviceManager device = p.Provider.of<DeviceManager>(context, listen: false);
  bool userExists = false;
  User user;
  if (supabase.auth.currentSession != null) {
    user = Supabase.instance.client.auth.currentSession!.user;
    //userExists = await userExistsinDb(password: user.email.toString());
  }
  supabase.auth
      .signInWithOAuth(provider, redirectTo: 'pantherapp://auth/v1/callback');

  supabase.auth.onAuthStateChange.listen(
    ((event) async {
      if (await checkSession(context)) {
        a.setValuesAuto();

        if (!userExists)
          Navigator.of(context).pushReplacementNamed(device.getRoute());
      }
    }),
  );
}

Future<String> getUserRole({required int id}) async {
  final users = await supabase
      .from('user_roles')
      .select('''role: role_id (role)''')
      .eq('user_id', id)
      .single();

  return users['role']['role'];
}

Future<String> getUserRoleAuto() async {
  final users = await supabase
      .from('user_roles')
      .select('''role: role_id (role)''')
      .eq('user_id', await getCurrentUserIdInt())
      .single();
  return users['role']['role'];
}

//check if there is active session and push page if there is
Future<bool> checkSession(BuildContext context) async {
  if (supabase.auth.currentSession != null) {
    //AppSetup a = p.Provider.of<AppSetup>(context, listen: false);
    //a.role = await getUserRoleAuto();
    return true;
  }
  return false;
}

Future<void> signOut(BuildContext context) async {
  await supabase.auth.signOut();
}

Future<Map> getCurrentUserIdInt() async {
  final userData = await supabase
      .from('users')
      .select('id, email, full_name, role, department')
      .eq('uuid', supabase.auth.currentUser!.id)
      .single();

  return userData;
}
