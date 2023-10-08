import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/widgets/race_track_selector.dart';
import 'package:flutter_complete_guide/widgets/vehicle_selector.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../queries.dart';

List sessionsFinal = [TextEditingController(text: 'Session 1')];

showEventSetupDialog({
  required BuildContext context,
}) {
  AppSetup setup = Provider.of<AppSetup>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      TextEditingController eventDescriptionController =
          TextEditingController();
      return AlertDialog(
        title: Text('Setup Event Day'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Mutation(
            options: MutationOptions(document: gql(insertEvent)),
            builder: (RunMutation insertEvent, result) {
              return TextButton(
                onPressed: () {
                  print('hello world');
                  List<Map<String, dynamic>> s = [];
                  for (var sessionType in sessionsFinal) {
                    s.add({
                      "racetrack_id":
                          setup.races2023[setup.raceSelectorIndex].id,
                      "type": sessionType.text.toString(),
                      "session_order": (sessionsFinal.indexWhere(
                                  (element) => element == sessionType) +
                              1)
                          .toString(),
                      "proposal_pools": {
                        "data": {
                          "vehicle_id": setup.proposalVehicle.id,
                          "proposals": {
                            "data": [
                              {
                                "title": "Health Check 1",
                                "description": "",
                                "reason": ""
                              },
                              {
                                "title": "Health Check 2",
                                "description": "",
                                "reason": ""
                              }
                            ]
                          }
                        }
                      }
                    });
                  }
                  print(s);
                  insertEvent({
                    "description": eventDescriptionController.text,
                    "date": DateTime.now().toString(),
                    "sessions": s,
                  });
                  print({
                    "description": eventDescriptionController.text,
                    "date": DateTime.now(),
                    "sessions": s,
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              );
            },
          ),
        ],
        content: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  myTextField(
                    controller: eventDescriptionController,
                    label: 'Event Description',
                  ),
                  SizedBox(height: height * 0.02),
                  Center(child: RaceTrackSelector()),
                  SizedBox(height: height * 0.02),
                  Center(child: VehicleSelector()),
                  SizedBox(height: height * 0.005 - 1),
                  SessionList()
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class SessionList extends StatefulWidget {
  const SessionList({super.key});

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  List<TextEditingController> sessionTypes = [
    TextEditingController(text: 'Session 1')
  ];
  late List<Widget> sessions = [
    SessionTile(
      id: 0,
      controller: sessionTypes[0],
      deleteSessionFunction: deleteSession,
    )
  ];
  late int key = 1;

  updateKey() {
    int sum = 0;
    for (int i = 0; i < sessions.length; i++) {
      sum += sessions.length;
    }
    key = sum;
    sessionsFinal = sessionTypes;
  }

  deleteSession({required int id}) {
    setState(() {
      sessions.replaceRange(id, id + 1, [Container()]);
      sessionTypes[id].text = 'deleted';
      updateKey();
    });
  }

  addSession() {
    setState(() {
      sessionTypes.add(TextEditingController(
          text: 'Session ' + (sessionTypes.length + 1).toString()));
      sessions.add(
        SessionTile(
          id: sessions.length,
          controller: sessionTypes[sessionTypes.length - 1],
          deleteSessionFunction: deleteSession,
        ),
      );
      updateKey();
    });
  }

  returnSessions() {
    List<Widget> list = [];
    for (int i = 0; i < sessions.length; i++) {
      if (sessionTypes[i].text != 'deleted') {
        list.add(sessions[i]);
        list.add(SizedBox(height: 10));
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    print('build initiated');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.5,
      child: Column(
        children: [
          SafeArea(
            child: TextButton(
              child: Text('Add Session'),
              onPressed: () => addSession(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: Key(key.toString()),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ...returnSessions()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextField myTextField({
  required TextEditingController controller,
  required String label,
}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
      ),
    );

// ignore: must_be_immutable
class SessionTile extends StatelessWidget {
  SessionTile({
    required int this.id,
    required TextEditingController this.controller,
    required Function({required int id}) this.deleteSessionFunction,
  });
  int id;
  TextEditingController controller;
  Function({required int id}) deleteSessionFunction;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          width: width * 0.65,
          height: 50,
          child: myTextField(controller: controller, label: 'Session Type'),
        ),
        IconButton(
          onPressed: () {
            deleteSessionFunction(id: id);
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
