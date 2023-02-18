import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/dark_theme_icons.dart';
import 'package:flutter_complete_guide/widgets/signIn_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../names.dart';
import '../providers/device.dart';
import './signInTextField.dart';
import '../supabase/authentication_functions.dart';
import 'package:provider/provider.dart' as provider;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

var minimumWidth = 280.0;
var minimumButtonHeight = 40.0;

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
      showSignInAlertDialog(context: context, errorMessage: insert_email);
    } else if (passwordController.text.isEmpty) {
      //checks if password textfield is empty
      showSignInAlertDialog(context: context, errorMessage: insert_password);
    } else if (!signedUp &&
        passwordController.text != confirmPasswordController.text) {
      //checks if password and confirm password textfields have matching values
      showSignInAlertDialog(
          context: context, errorMessage: passwords_not_matching);
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
    DeviceManager device = provider.Provider.of<DeviceManager>(context);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (device.isTablet || device.isPhone) {
      //check for tablet -still mobile device but bigger screen
      if (width > 480) {
        width = width * 0.7;
      } else
        width = width;
      //check for everything that is not mobile
    } else {
      width = width * 0.35;
    }

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
                  signedUp ? sign_in : sign_up,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                //button for theme control
                Align(
                  child: DarkThemeButton(
                      context: context, darkThemeColor: Colors.yellow),
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
              labelText: email,
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
              labelText: password,
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
                    labelText: confirm_password,
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
                      child: Text(
                        forgot_password,
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
                  : Text(login),
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
              Text(signedUp ? no_account : have_account),
              IgnorePointer(
                ignoring: isLoading,
                child: TextButton(
                  child: Text(
                    signedUp ? sign_up : sign_in,
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
          ThirdPartySignInButton(
            height: height,
            width: width,
            isLoading: isLoading,
            auth: 'Google',
          ),
          SizedBox(
            height: height * 0.01,
          ),
          ThirdPartySignInButton(
            height: height,
            width: width,
            isLoading: isLoading,
            auth: 'Facebook',
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
              onPressed: () => Navigator.of(context).pushReplacementNamed(
                  device.isDesktopMode() ? '/main-desktop' : '/main-mobile'),
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
                    Text(powered),
                    Text(
                      panther_tm,
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

class ThirdPartySignInButton extends StatelessWidget {
  const ThirdPartySignInButton({
    Key? key,
    required this.height,
    required this.width,
    required this.isLoading,
    required this.auth,
  }) : super(key: key);

  final double height;
  final double width;
  final bool isLoading;
  final String auth;

  Icon i() {
    if (auth == 'Facebook') return Icon(FontAwesomeIcons.facebook);
    if (auth == 'Google') return Icon(FontAwesomeIcons.google);
    return Icon(FontAwesomeIcons.a);
  }

  String s() {
    if (auth == 'Facebook') return sign_in_facebook;
    if (auth == 'Google') return sign_in_google;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //sign in with third party button
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
            icon: i(),
            label: Text(s()),
            onPressed: () {
              if (auth == 'Facebook')
                signInWithOAuth(context, provider: Provider.facebook);
              if (auth == 'Google')
                signInWithOAuth(context, provider: Provider.google);
            }),
      ),
    );
  }
}
