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
    dataFuture = getUsersWithRoles();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (FutureBuilder<List>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List users = snapshot.data![1];
          users.sort(
            (a, b) {
              return a['role']['role'].compareTo(b['role']['role']);
            },
          );

          List roles = [];
          snapshot.data![0].forEach((element) {
            roles.add(Role(element['id'], element['role']));
          });

          List<DropdownMenuItem<Role>> allRolesDropdown = [];
          roles.forEach((element) {
            allRolesDropdown.add(DropdownMenuItem<Role>(
                child: Text(element.role_name), value: element));
          });

          List<Role> currentValue = [];
          for (int i = 0; i < users.length; i++) {
            for (int j = 0; j < allRolesDropdown.length; j++) {
              if (users[i]['role']['role'] ==
                  allRolesDropdown[j].value!.role_name)
                currentValue.add(allRolesDropdown[j].value!);
            }
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                          label: TextButton(
                        child: Text('Apply'),
                        onPressed: () {
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
                            newMap.add({
                              'id': element['primary_id'],
                              'last_modified': DateTime.now().toString(),
                              'role_id': element['role']['role'],
                            });
                          });

                          updateUserRoles(newMap);
                        },
                      )),
                    ],
                    rows: [
                      for (int i = 0; i < users.length; i++)
                        DataRow(
                          cells: [
                            DataCell(Text((i + 1).toString())),
                            DataCell(Text(users[i]['user']['full_name'])),
                            DataCell(Text(users[i]['user']['department'])),
                            DataCell(Text(users[i]['user']['role'])),
                            DataCell(DropdownButton(
                              value: currentValue[i],
                              items: allRolesDropdown,
                              onChanged: ((Role? value) {
                                setState(() {
                                  users[i]['role']['role'] = value!.role_name;
                                });
                              }),
                            )),
                            DataCell(
                              Text(DateTime.parse(users[0]['created_at'])
                                  .toString()),
                            ),
                            DataCell(Text(
                                DateTime.parse(users[0]['last_modified'])
                                    .toString())),
                            DataCell(
                              IconButton(
                                disabledColor: Theme.of(context).primaryColor,
                                onPressed: (users[i]['role']['role'] == 'admin')
                                    ? null
                                    : () {},
                                icon: Icon((users[i]['role']['role'] == 'admin')
                                    ? Icons.shield_sharp
                                    : Icons.edit),
                              ),
                            ),
                          ],
                        ),
                    ])
              ]);
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
