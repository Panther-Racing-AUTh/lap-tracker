import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/about_screen.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/settings_screen.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import 'package:flutter_complete_guide/widgets/chats_total.dart';
import '../../widgets/main_appbar.dart';

class ChatScreen extends StatelessWidget {
  void _showAccountPopupMenu(BuildContext context,int viewIndex) {

    late bool getBool;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final double buttonWidth = button.size.width;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double dx = screenWidth ;
    final double dy = 100;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      items: [
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {

            if(viewIndex==DrawerIndexValue.home.getInt()){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
            }
          },
          child: Row(

            children: [
              Icon(Icons.account_circle),
              SizedBox(width: 10,),
              Text('Profile')
            ],
          ),

        ),
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {


            if(viewIndex==DrawerIndexValue.home.getInt()){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
            }          },
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 10,),
              Text('Settings')
            ],
          ),

        ),
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {


            if(viewIndex==DrawerIndexValue.home.getInt()){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen(),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AboutScreen(),));
            }            },
          child: Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 10,),
              Text('About')
            ],
          ),

        ),
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {
            signOut(context);

          },
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 10,),
              Text('Logout`')
            ],
          ),

        ),

      ],
    ).then((value) {
      if (value != null) {

      }
    });
  }

  //static const String routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(chat),
        actions: [
          GestureDetector(
              onTap: () {
                _showAccountPopupMenu(context, DrawerIndexValue.chat.getInt());
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
      drawer: DrawerModel(context,DrawerIndexValue.chat.getInt()),

      body: ChatLandingPage(() {}),
    );
  }
}
