import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  print(user);
  print("Inserted User");
  await supabase.from('user_roles').insert({
    'user_id': user[0]['id'],
    'role_id': 4,
  });
  print("Inserted User Role");
}

//login already existing user
Future<void> userLogin({
  required final String email,
  required final String password,
  required final bool signedUp,
  required final BuildContext context,
  required final bool userExists,
}) async {
  print(1);
  AppSetup a = p.Provider.of<AppSetup>(context, listen: false);
  print(2);
  DeviceManager device = p.Provider.of<DeviceManager>(context, listen: false);
  print(3);
  final test = supabase.from('part').select('id');
  print(test);
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print(4);

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
    await Future.delayed(const Duration(seconds: 1));
    showSignInAlertDialog(context: context, errorMessage: "Account created!");
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
  bool _isAuthorized = false;
  User user;
  if (supabase.auth.currentSession != null) {
    user = Supabase.instance.client.auth.currentSession!.user;
    //userExists = await userExistsinDb(password: user.email.toString());
  }
  const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  // supabase.auth.signInWithOAuth(provider,
  //     redirectTo: 'https://pwqrcfdxmgfavontopyn.supabase.co/auth/v1/callback');

  /// TODO: update the Web client ID with your own.
  ///
  /// Web Client ID that you registered with Google Cloud.
  const webClientId =
      '629744579995-j0sk14he0a48pd94tb2nmdps4s7gdg16.apps.googleusercontent.com';

  /// TODO: update the iOS client ID with your own.
  ///
  /// iOS Client ID that you registered with Google Cloud.
  const iosClientId =
      '629744579995-68uojdkql66s9tf63u34tcmmj7e95fis.apps.googleusercontent.com';

  // Google sign in on Android will work without providing the Android
  // Client ID registered on Google Cloud.
  GoogleSignIn _googleSignInWeb = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: scopes,
  );
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  _googleSignInWeb.onCurrentUserChanged
      .listen((GoogleSignInAccount? account) async {
// #docregion CanAccessScopes
    // In mobile, being authenticated means being authorized...
    bool isAuthorized = account != null;
    // However, on web...
    if (kIsWeb) {
      isAuthorized = await _googleSignInWeb.canAccessScopes(scopes);
    }
  });
  // _googleSignInWeb.signInSilently();

  final googleUser = await _googleSignInWeb.signInSilently();
  print(1);
  final googleAuth = await googleUser!.authentication;
  print(2);

  final accessToken = googleAuth.accessToken;
  print(3);

  var idToken = googleAuth.idToken;
  print(4);

  // if (accessToken == null) {
  //   throw 'No Access Token found.';
  // }
  print(5);

  if (idToken == null) {
    throw 'No ID Token found.';
  }
  print(6);

  await supabase.auth.signInWithIdToken(
    provider: Provider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
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
      .select('''role: role_id (role)''').eq('user_id', id);
  print('users: ');
  print(users);
  if (users.toList().isEmpty) {
    await supabase.from('user_roles').insert({
      'user_id': id,
      'role_id': 4,
    });
    return 'default';
  }
  return users[0]['role']['role'];
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
  AppSetup a = p.Provider.of<AppSetup>(context, listen: false);
  await supabase.auth.signOut();
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.of(context).pushReplacementNamed('/signin');
  BuildContext? dcontext;
  a.supabase_id = -1;
  a.role = 'a';
  showDialog(
    barrierDismissible: false,
    builder: (ctx) {
      dcontext = ctx;
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    },
    context: context,
  );

  await Future.delayed(Duration(milliseconds: 500));
  a.setIndex(0);
  a.role = '';
  await Future.delayed(Duration(milliseconds: 500));
  Navigator.of(dcontext!, rootNavigator: true).pop();
}

Future<Map> getCurrentUserIdInt() async {
  print(
      "Supabase Current User ID: " + supabase.auth.currentUser!.id.toString());
  final userData = await supabase
      .from('users')
      .select('id, email, full_name, role, department')
      .eq('uuid', supabase.auth.currentUser!.id)
      .single();
  return userData;
}
