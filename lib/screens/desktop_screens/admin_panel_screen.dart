import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../supabase/admin_functions.dart';

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
    dataFuture = getUsersWithRoles();
  }

  @override
  Widget build(BuildContext context) {
    return (Supabase.instance.client.auth.currentUser != null)
        ? Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text(
                'Sign In to see Admin Panel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          )
        : FutureBuilder<List>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final users = snapshot.data;

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
                            DataColumn(label: Container()),
                          ],
                          rows: [
                            for (int i = 0; i < users!.length; i++)
                              DataRow(
                                cells: [
                                  DataCell(Text(i.toString())),
                                  DataCell(Text(users[i]['user']['full_name'])),
                                  DataCell(
                                      Text(users[i]['user']['department'])),
                                  DataCell(Text(users[i]['user']['role'])),
                                  DataCell(Text(users[i]['role']['role'])),
                                  DataCell(
                                    Text(DateTime.parse(users[0]['created_at'])
                                        .toString()),
                                  ),
                                  DataCell(Text(
                                      DateTime.parse(users[0]['last_modified'])
                                          .toString())),
                                  DataCell(
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.edit)),
                                  ),
                                ],
                              ),
                          ])
                    ]);
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }
}
