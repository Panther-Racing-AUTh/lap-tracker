import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/main_screen.dart';




class PreReleaseScreen extends StatefulWidget {
  @override
  _PreReleaseScreenState createState() => _PreReleaseScreenState();
}

class _PreReleaseScreenState extends State<PreReleaseScreen> {
  List<String> futureReleases=['Weekly Expenses tracker','Motorcycle break down & details'];

  List<String> doneReleases=['Weekly Report', 'Link supabase with calendar'];
  

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
        centerTitle: false,
        title: Text(future_releases),
      ),
      body: Center(
        child: ListView(
          
          children: [
            Image.asset('assets/new_features-2.png'),
            Container(
              child: Text("Future Gadgets",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.grey.shade600),textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.blue,
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: futureReleases.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                    child: Row(
                      children: [
                        Icon(Icons.circle,size: 25,),
                        SizedBox(width: 25,),
                        Expanded(child: Text(item,style: TextStyle(fontSize: 18),))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Text("Available Gadgets",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.grey.shade600),textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blue,
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: doneReleases.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                    child: Row(
                      children: [
                        Icon(Icons.check,size: 25,color: Colors.green,),
                        SizedBox(width: 25,),
                        Expanded(child: Text(item,style: TextStyle(fontSize: 18),))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
