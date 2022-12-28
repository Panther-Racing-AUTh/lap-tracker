import 'package:flutter/material.dart';
import '../widgets/login.dart';

class SigninScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Container(
            child: Login(),
            height: MediaQuery.of(context).size.height * 0.88,
          ),
        ],
      ),
    );
  }
}
