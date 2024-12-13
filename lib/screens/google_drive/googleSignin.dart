import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/providers/device.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as p; // Assuming you're using Provider for state management

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  GoogleSignInAccount? _currentUser;
  GoogleSignInAuthentication? googleAuth;
  String? accessToken;
  String? idToken;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (account != null) {
        _handleSignIn();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      AppSetup a = p.Provider.of<AppSetup>(context, listen: false);
      DeviceManager device = p.Provider.of<DeviceManager>(context, listen: false);

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print('Sign-in process was cancelled or failed.');
        return;
      }

      googleAuth = await account.authentication;
      setState(() {
        accessToken = googleAuth!.accessToken;
        idToken = googleAuth!.idToken;
      });

      print('Access Token: $accessToken');
      print('ID Token: $idToken');

      if (accessToken == null) {
        throw 'No Access Token found.';
      }

      if (idToken == null) {
        throw 'No ID Token found.';
      }

      print('Authentication successful.');

      // Sign in with Supabase using Google ID token and access token
      final response = await supabase.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: idToken!,
        accessToken: accessToken!,
      );

      final user = response.user;

      // Insert or update user details in Supabase 'users' table
      final userExists = await _checkUserExists(user!.id);

      if (!userExists) {
        await supabase.from('users').insert({
          'uuid': user.id,
          'email': user.email,
          'password': null, // Password is null for Google sign-in
          'full_name': user.email,
          'provider': 'google',
          'created_at': DateTime.now().toIso8601String(),
          'about': '',
          'role': 'user', // Default role
          'department': '',
          'active': true,
        });
      }

      supabase.auth.onAuthStateChange.listen(
            (event) async {
          if (await checkSession(context)) {
            a.setValuesAuto();

            if (!userExists)
              Navigator.of(context).pushReplacementNamed(device.getRoute());
          }
        },
      );

    } catch (error) {
      print('Error during sign-in: $error');
    }
  }

  Future<bool> _checkUserExists(String userId) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('uuid', userId)
        .single()
        .execute();

    return response.data != null;
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    setState(() {
      _currentUser = null;
      googleAuth = null;
      accessToken = null;
      idToken = null;
    });
  }

  Future<bool> checkSession(BuildContext context) async {
    // Implement your session check logic here
    return true; // Placeholder return value
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Example'),
      ),
      body: Center(
        child: user != null
            ? ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: user,
              ),
              title: Text(user.displayName ?? ''),
              subtitle: Text(user.email),
            ),
            Text('Google Auth: $googleAuth'),
            Text('Access Token: $accessToken'),
            Text('ID Token: $idToken'),
            ElevatedButton(
              child: Text('SIGN OUT'),
              onPressed: _handleSignOut,
            ),
          ],
        )
            : ElevatedButton(
          child: Text('SIGN IN'),
          onPressed: () => signInWithOAuthOriginal(context,provider: Provider.google),
        ),
      ),
    );
  }
}
