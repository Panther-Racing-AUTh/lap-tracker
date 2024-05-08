import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/widgets/settings.dart';
import '../../widgets/main_appbar.dart';

class SettingsScreen extends StatelessWidget {
  //static const String routeName = '/settings';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(settings),
        actions: [
          GestureDetector(
              onTap: () {


              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Image.asset('assets/panther_logo_transparent.png',errorBuilder: (context, error, stackTrace) => Icon(Icons.account_circle,size: 40,),),
              )
          )
        ],
      ),
      drawer: DrawerModel(context,DrawerIndexValue.settings.getInt()),
      body: Settings(),
    );
  }
}
