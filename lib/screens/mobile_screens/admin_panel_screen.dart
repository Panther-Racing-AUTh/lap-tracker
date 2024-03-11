import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/person.dart';
import 'package:flutter_complete_guide/models/role.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/admin_panel_screen_desktop.dart';
import 'package:flutter_complete_guide/supabase/admin_functions.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Admin Panel',
        ),
      ),
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
