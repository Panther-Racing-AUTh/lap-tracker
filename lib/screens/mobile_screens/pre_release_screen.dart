import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/main_screen.dart';




class PreReleaseScreen extends StatefulWidget {
  @override
  _PreReleaseScreenState createState() => _PreReleaseScreenState();
}

class _PreReleaseScreenState extends State<PreReleaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(),));
          },
          child: Icon(Icons.close),
        ),
        title: Text('Pre-Release Page'),
      ),
      body: Center(
        child: ListView(
          children: [
            Text(
              'Welcome to the Pre-Release Version!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Explore new features and provide feedback.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
