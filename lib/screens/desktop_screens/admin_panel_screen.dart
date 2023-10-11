import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/supabase/chat_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../supabase/admin_functions.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with AutomaticKeepAliveClientMixin<AdminPanel> {
  @override
  bool get wantKeepAlive => true;

  late Future<List> dataFuture;

  @override
  void initState() {
    super.initState();
    //future initialization
    dataFuture = getUsersWithRoles();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (FutureBuilder<List>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //assign future result to local variable
          List users = snapshot.data![1];
          //sort users according to their role
          users.sort(
            (a, b) {
              return a['role']['role'].compareTo(b['role']['role']);
            },
          );

          List roles = [];
          //assign all the different roles to local variable
          snapshot.data![0].forEach((element) {
            roles.add(Role(element['id'], element['role']));
          });

          //create the dropdown-menu
          List<DropdownMenuItem<Role>> allRolesDropdown = [];
          roles.forEach((element) {
            allRolesDropdown.add(DropdownMenuItem<Role>(
                child: Text(element.role_name), value: element));
          });

          //current role for each user to initialize the dropdown-menu
          List<Role> currentValue = [];
          for (int i = 0; i < users.length; i++) {
            for (int j = 0; j < allRolesDropdown.length; j++) {
              if (users[i]['role']['role'] ==
                  allRolesDropdown[j].value!.role_name)
                currentValue.add(allRolesDropdown[j].value!);
            }
          }

          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //table columns
                  DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.grey.shade200),
                      columns: [
                        DataColumn(label: Text("No")),
                        DataColumn(label: Text("Profile")),
                        DataColumn(label: Text("Department")),
                        DataColumn(label: Text("Team Role")),
                        DataColumn(label: Text("Role")),
                        DataColumn(label: Text("Created At")),
                        DataColumn(label: Text("Last Modified At")),
                        DataColumn(
                            //button to apply role changes
                            label: TextButton(
                          child: Text('Apply'),
                          onPressed: () {
                            //for each user the role is changed
                            for (int i = 0; i < users.length; i++) {
                              users[i]['role']['role'] = roles
                                  .firstWhere(
                                    (element) =>
                                        users[i]['role']['role'] ==
                                        element.role_name,
                                  )
                                  .id;
                            }
                            List<Map> newMap = [];
                            users.forEach((element) {
                              //replace the old user role with new one and change 'last modified' field
                              newMap.add({
                                'id': element['primary_id'],
                                'last_modified': DateTime.now().toString(),
                                'role_id': element['role']['role'],
                              });
                            });
                            //update roles on database
                            updateUserRoles(newMap);
                          },
                        )),
                      ],
                      rows: [
                        for (int i = 0; i < users.length; i++)
                          DataRow(
                            //row with information for each user
                            cells: [
                              DataCell(Text((i + 1).toString())),
                              //user name
                              DataCell(Text(users[i]['user']['full_name'])),
                              //user department
                              DataCell(Text(users[i]['user']['department'])),
                              //user role
                              DataCell(Text(users[i]['user']['role'])),
                              //dropdown button for user role reassigning
                              DataCell(DropdownButton(
                                value: currentValue[i],
                                items: allRolesDropdown,
                                onChanged: ((Role? value) {
                                  setState(() {
                                    users[i]['role']['role'] = value!.role_name;
                                  });
                                }),
                              )),
                              //'created at' field
                              DataCell(
                                Text(DateTime.parse(users[i]['created_at'])
                                    .toString()),
                              ),
                              //'last modified at' field
                              DataCell(Text(
                                  DateTime.parse(users[i]['last_modified'])
                                      .toString())),
                              DataCell(
                                //decorative button
                                IconButton(
                                  disabledColor: Theme.of(context).primaryColor,
                                  onPressed:
                                      (users[i]['role']['role'] == 'admin')
                                          ? null
                                          : () {},
                                  icon: Icon(
                                      (users[i]['role']['role'] == 'admin')
                                          ? Icons.shield_sharp
                                          : Icons.edit),
                                ),
                              ),
                            ],
                          ),
                      ])
                ]),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}

class Role {
  int id;
  String role_name;
  Role(this.id, this.role_name);
}
