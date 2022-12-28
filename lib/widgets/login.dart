import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/signIn_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './signInTextField.dart';
import '../supabase/authentication_functions.dart';
import 'package:provider/provider.dart' as provider;
import '../providers/theme.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  bool signedUp =
      true; //checks if user is trying to sign up or sign in and controls what is shown on screen
  bool userExists = false; //shows if a user is already signed up to supabase
  bool isLoading = false; //shows if a request is pending to supabase
  bool obscure = true; //determines if password is visible

  //controllers for each textfield: email, password and confirm password
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //function that runs when 'Login' button is pressed; signs in or up the user
  Future<void> _loginPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    if (emailController.text.isEmpty) {
      //check if email textfield is empty
      showSignInAlertDialog(
          context: context, errorMessage: 'Insert an email address!');
    } else if (passwordController.text.isEmpty) {
      //checks if password textfield is empty
      showSignInAlertDialog(
          context: context, errorMessage: 'Insert a password!');
    } else if (!signedUp &&
        passwordController.text != confirmPasswordController.text) {
      //checks if password and confirm password textfields have matching values
      showSignInAlertDialog(
          context: context, errorMessage: 'The two passwords do not match!');
    } else {
      userExists = await userExistsinDb(
          email: emailController
              .text); //calls function to determine if user is already registered
      !signedUp
          ? userSignUp(
              //signs up user by contacting supabase
              email: emailController.text,
              password: passwordController.text,
              signedUp: signedUp,
              userExists: userExists,
              context: context,
            )
          : await userLogin(
              //signs in user by contacting supabase
              email: emailController.text,
              password: passwordController.text,
              signedUp: signedUp,
              userExists: userExists,
              context: context,
            );
      //if user is already in database and tries to sign up, he is redirected to login
      if (userExists && !signedUp) {
        passwordController.clear();
        confirmPasswordController.clear();
        signedUp = true;
        setState(() {});
      }
    }

    setState(() {
      isLoading = false;
    });
  }

//button that makes password (in)visible.
  IconButton _hidePasswordButton() {
    return IconButton(
      padding: EdgeInsets.only(right: 10),
      onPressed: () {
        setState(() {
          obscure = !obscure;
        });
      },
      icon: Icon(
        obscure == true ? Icons.visibility_off : Icons.visibility,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = provider.Provider.of<ThemeChanger>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      //check for tablet -still mobile device but bigger screen
      if (width > 480) {
        width = width * 0.7;
      } else
        width = width;
      //check for everything that is not mobile
    } else {
      width = width * 0.35;
    }
    var minimumWidth = 280.0;
    var minimumButtonHeight = 40.0;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              minHeight: 60,
              minWidth: minimumWidth,
            ),
            height: height * 0.075,
            width: width * 0.95,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.01),
            child: Stack(
              alignment: Alignment.center,
              children: [
                //page title
                Text(
                  signedUp ? 'Sign In' : 'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                //button for theme control
                Align(
                  child: IconButton(
                    icon: _themeChanger.getTheme() == ThemeData.light()
                        ? Icon(Icons.light_mode_sharp)
                        : Icon(
                            Icons.dark_mode_sharp,
                            color: Colors.yellow,
                          ),
                    onPressed: (() {
                      _themeChanger.getTheme() == ThemeData.light()
                          ? _themeChanger.setTheme(ThemeData.dark())
                          : _themeChanger.setTheme(ThemeData.light());
                    }),
                  ),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            //email textfield -calls widget from another file
            constraints: BoxConstraints(
              minHeight: minimumButtonHeight,
              minWidth: minimumWidth,
            ),
            height: height * 0.075,
            width: width * 0.95,
            padding: EdgeInsets.fromLTRB(width * 0.01, 0, width * 0.01, 0),
            child: signInTextField(
              controller: emailController,
              labelText: 'Email',
              emailKeyboard: true,
            ),
          ),
          Container(
            //password textfield -calls widget from another file
            constraints: BoxConstraints(
              minHeight: minimumButtonHeight,
              minWidth: minimumWidth,
            ),
            height: height * 0.075,
            width: width * 0.95,
            padding: EdgeInsets.fromLTRB(width * 0.01, 0, width * 0.01, 0),
            child: signInTextField(
              controller: passwordController,
              labelText: 'Password',
              iconButton: _hidePasswordButton(),
              obscured: obscure,
            ),
          ),
          !signedUp //checks if user is trying to sign up or login and shows extra confirm password textfield
              ? Container(
                  constraints: BoxConstraints(
                    minWidth: minimumWidth,
                    minHeight: minimumButtonHeight,
                  ),
                  height: height * 0.075,
                  width: width * 0.95,
                  padding:
                      EdgeInsets.fromLTRB(width * 0.01, 0, width * 0.01, 0),
                  child: signInTextField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    iconButton: _hidePasswordButton(),
                    obscured: obscure,
                  ),
                )
              : Container(
                  //forgot password button
                  constraints: BoxConstraints(
                    minWidth: minimumWidth,
                    minHeight: 20,
                  ),
                  width: width * 0.95,
                  padding:
                      EdgeInsets.fromLTRB(height * 0.01, 0, height * 0.01, 0),
                  child: IgnorePointer(
                    ignoring: isLoading,
                    child: TextButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      child: const Text(
                        'Forgot Password',
                      ),
                    ),
                  ),
                ),
          Container(
            //login button
            constraints: BoxConstraints(
              minHeight: minimumButtonHeight,
              minWidth: minimumWidth,
            ),
            height: height * 0.052,
            width: width * 0.95,
            padding: EdgeInsets.fromLTRB(width * 0.025, 0, width * 0.025, 0),
            child: ElevatedButton(
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text('Login'),
              onPressed: (() {
                if (!isLoading) {
                  _loginPressed(context);
                }
              }),
            ),
          ),
          Row(
            children: <Widget>[
              //button to change from login to sign up and vice versa
              Text(signedUp
                  ? 'Don\'t have an account?'
                  : 'Already have an account?'),
              IgnorePointer(
                ignoring: isLoading,
                child: TextButton(
                  child: Text(
                    signedUp ? 'Sign Up' : 'Sign In',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (signedUp)
                      signedUp = false;
                    else
                      signedUp = true;
                    setState(() {});
                  },
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            height: height * 0.012,
          ),
          Text('-- OR --'),
          SizedBox(
            height: height * 0.022,
          ),
          Container(
            //sign in with google button
            constraints: BoxConstraints(
              minHeight: minimumButtonHeight,
              minWidth: minimumWidth,
            ),
            height: height * 0.052,
            width: width * 0.95,
            padding: EdgeInsets.fromLTRB(width * 0.025, 0, width * 0.025, 0),
            child: IgnorePointer(
              ignoring: isLoading,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Icon(FontAwesomeIcons.google),
                label: Text('Sign in with Google'),
                onPressed: () => signInWithOAuth(
                  context,
                  provider: Provider.google,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            //sign in with facebook button
            constraints: BoxConstraints(
              minHeight: minimumButtonHeight,
              minWidth: minimumWidth,
            ),
            height: height * 0.052,
            width: width * 0.95,
            padding: EdgeInsets.fromLTRB(width * 0.025, 0, width * 0.025, 0),
            child: IgnorePointer(
              ignoring: isLoading,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Icon(FontAwesomeIcons.facebook),
                label: Text('Sign in with Facebook'),
                onPressed: () =>
                    signInWithOAuth(context, provider: Provider.facebook),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
            child: TextButton(
              child: Text(
                'Continue as admin',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                ),
              ),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/main'),
            ),
          ),
          Column(
            //'powered by panther' text
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 20),
                child: SizedBox(height: height * 0.1),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Powered by  '),
                    Text(
                      'Panther Racing AUTh™',
                      style: TextStyle(
                          color: Color.fromARGB(255, 6, 103, 145),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
