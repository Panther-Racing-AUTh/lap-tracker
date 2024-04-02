import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/person.dart';
import 'package:flutter_complete_guide/models/role.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/admin_panel_screen_desktop.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/about_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/drawer_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/settings_screen.dart';
import 'package:flutter_complete_guide/supabase/admin_functions.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Future<List> dataFuture;

  @override
  void initState() {
    super.initState();
    //future initialization
    dataFuture = getUsersWithRoles();
  }

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Calendar'),
        actions: [
          GestureDetector(
              onTap: () {
                _showAccountPopupMenu(context, DrawerIndexValue.admin.getInt());
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
      drawer: DrawerModel(context,DrawerIndexValue.admin.getInt()),

      body: AdminPanelDesktop(),
    );
    //     body: SizedBox(
    //       height: MediaQuery.of(context).size.height,
    //       width: MediaQuery.of(context).size.width,
    //       child: FutureBuilder<List>(
    //         future: dataFuture,
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.done) {
    //             //assign future result to local variable
    //             List users = snapshot.data![1];
    //             //sort users according to their role
    //             users.sort(
    //               (a, b) {
    //                 return a['role']['role'].compareTo(b['role']['role']);
    //               },
    //             );

    //             List<Role> roles = [];
    //             //assign all the different roles to local variable
    //             snapshot.data![0].forEach((element) {
    //               roles.add(Role(element['id'], element['role']));
    //             });
    //             //full list of users with appropriate data type
    //             List<Person> usersFinal = [];
    //             users.forEach(
    //               (user) {
    //                 usersFinal.add(Person.fromJson(user['user']));
    //                 usersFinal.last.appRole = roles.firstWhere(
    //                     (role) => role.role_name == user['role']['role']);
    //                 usersFinal.last.created_at = user['created_at'];
    //                 usersFinal.last.last_modified = user['last_modified'];
    //               },
    //             );

    //             //create the dropdown-menu
    //             List<DropdownMenuItem<Role>> allRolesDropdown = [];
    //             roles.forEach((element) {
    //               allRolesDropdown.add(DropdownMenuItem<Role>(
    //                   child: Text(element.role_name), value: element));
    //             });

    //             //current role for each user to initialize the dropdown-menu
    //             List<Role> currentValue = [];
    //             for (int i = 0; i < users.length; i++) {
    //               for (int j = 0; j < allRolesDropdown.length; j++) {
    //                 if (users[i]['role']['role'] ==
    //                     allRolesDropdown[j].value!.role_name)
    //                   currentValue.add(allRolesDropdown[j].value!);
    //               }
    //             }
    //             void changeRole({required Role value, required int personId}) {
    //               setState(() {
    //                 usersFinal
    //                     .firstWhere((element) => element.id == personId)
    //                     .appRole
    //                     .role_name = value.role_name;
    //               });
    //             }

    //             return SfDataGrid(
    //               allowEditing: true,
    //               navigationMode: GridNavigationMode.cell,
    //               selectionMode: SelectionMode.single,
    //               editingGestureType: EditingGestureType.tap,
    //               allowColumnsResizing: true,
    //               defaultColumnWidth: 150,
    //               rowHeight: 100,
    //               source: UserDataSource(
    //                   users: usersFinal,
    //                   allRolesDropdown: allRolesDropdown,
    //                   changeRoleFunction: changeRole),
    //               columns: AdminPanelColumns,
    //             );
    //           }
    //           return Center(child: CircularProgressIndicator());
    //         },
    //       ),
    //     ),
    //   );
    // }
  }
}
