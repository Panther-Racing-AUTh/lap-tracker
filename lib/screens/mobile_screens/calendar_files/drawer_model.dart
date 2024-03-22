import 'package:flutter/material.dart';

Widget DrawerModel(BuildContext context){
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Drawer Header',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Handle item 1 tap
            Navigator.pop(context); // Close the drawer
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Handle item 2 tap
            Navigator.pop(context); // Close the drawer
          },
        ),
        ListTile(
          title: Text('Item 3'),
          onTap: () {
            // Handle item 3 tap
            Navigator.pop(context); // Close the drawer
          },
        ),
      ],
    ),
  );
}
