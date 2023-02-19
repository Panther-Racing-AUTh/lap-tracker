import 'package:flutter_complete_guide/names.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../widgets/signIn_alert_dialog.dart';

final supabase = Supabase.instance.client;

//checks if user exists in database
Future<bool> userExistsinDb({required String email}) async {
  final data = await supabase.from('users').select().eq('email', email) as List;

  if (data.isEmpty) {
    return false;
  } else
    return true;
}

//insert user to database table
Future<void> insertUser({
  required String id,
  required String email,
  String password = '',
  required String provider,
}) async {
  bool userExists = await userExistsinDb(email: email);
  if (!userExists) {
    await supabase.from('users').insert({
      'id': supabase.auth.currentUser!.id,
      'email': email,
      'password': password,
      'provider': provider,
    });

    await supabase.from('users').insert({
      'id': supabase.auth.currentUser!.id,
    });
  }
}

//login already existing user
Future<void> userLogin({
  required final String email,
  required final String password,
  required final bool signedUp,
  required final BuildContext context,
  required final bool userExists,
}) async {
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final User? user = response.user;
    bool userExists = await userExistsinDb(email: email);
    //Checks if the user does not exist
    if (user != null) {
      //If there's no User inserts one in supabase table
      if (signedUp == false && !userExists) {
        await insertUser(
            id: supabase.auth.currentUser!.id,
            email: email,
            password: password,
            provider: 'email');
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed('/main');
    }
  } on AuthException catch (error) {
    if (!userExists && signedUp) {
      showSignInAlertDialog(context: context, errorMessage: user_not_found);
    } else if (signedUp) {
      showSignInAlertDialog(context: context, errorMessage: error.message);
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(confirm_email),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(cancel),
              ),
              TextButton(
                onPressed: () {
                  userLogin(
                    context: context,
                    password: password,
                    signedUp: signedUp,
                    userExists: userExists,
                    email: email,
                  );
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        },
      );
    }
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
    );

    //User? user = response.user;

    if (!userExists) {
      userLogin(
        context: context,
        password: password,
        signedUp: signedUp,
        userExists: userExists,
        email: email,
      );
    } else {
      showSignInAlertDialog(context: context, errorMessage: user_exists);
    }
  } on AuthException catch (error) {
    if (error.message != unconfirmed_email) {
      showSignInAlertDialog(context: context, errorMessage: error.message);
    }
  }
}

//sign in with OAuth
Future<void> signInWithOAuth(BuildContext context,
    {required Provider provider}) async {
  bool userExists = false;
  User user;
  if (supabase.auth.currentSession != null) {
    user = Supabase.instance.client.auth.currentSession!.user;
    userExists = await userExistsinDb(email: user.email.toString());
  }
  supabase.auth
      .signInWithOAuth(provider, redirectTo: 'pantherapp://auth/v1/callback');

  supabase.auth.onAuthStateChange.listen(
    ((event) async {
      if (checkSession()) {
        if (!userExists)
          insertUser(
              id: supabase.auth.currentUser!.id,
              email: supabase.auth.currentSession!.user.email.toString(),
              provider: provider.toString());
        Navigator.of(context).pushReplacementNamed('/main');
      }
    }),
  );
}

//check if there is active session and push page if there is
bool checkSession() {
  if (supabase.auth.currentSession != null) {
    return true;
  }
  return false;
}

Future<void> signOut() async {
  await supabase.auth.signOut();
}
