import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/event.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../queries.dart';

int _selected = -1;
List<Session> sessions = [];

showEventControlDialog({
  required BuildContext context,
}) {
  AppSetup setup = Provider.of<AppSetup>(context, listen: false);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(setup.eventDate.description),
              CircleAvatar(
                child: CountryFlags.flag(
                  setup.session.raceTrack.countryCode,
                  borderRadius: 10,
                ),
                // radius: 10,
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Mutation(
              options: MutationOptions(document: gql(selectSession)),
              builder: (selectSessionFun, result) {
                return TextButton(
                  child: Text('Save Changes'),
                  onPressed: () {
                    print(sessions[_selected].id);
                    print(setup.eventDate.id);
                    selectSessionFun({
                      "sessionId": sessions[_selected].id,
                      "eventId": setup.eventDate.id
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            )
          ],
          content: SizedBox(
            height: height * 0.7,
            width: width * 0.6,
            child: Query(
              options: QueryOptions(
                  document: gql(getEventDetails),
                  variables: {"eventId": setup.eventDate.id}),
              builder: (result, {fetchMore, refetch}) {
                if (result.hasException) {
                  print('exception');
                  print(result.exception);
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  print('loading');
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                }

                print(result.data);
                if (!result.source!.isEager) {
                  for (int i = 0;
                      i < result.data!['event_date'][0]['sessions'].length;
                      i++) {
                    print(i);
                    var session = result.data!['event_date'][0]['sessions'][i];
                    print(session);
                    sessions.add(Session.fromJson(session, []));
                    print(sessions[i].id);
                    if (session['proposal_pools'].isNotEmpty)
                      sessions[i].isActive = true;
                  }
                  _selected = -1;
                  calculateActiveSessionOfEvent();
                  print(_selected);
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Select Session: '),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: sessions.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(sessions[index].type),
                                      tileColor: (sessions[index].isActive)
                                          ? (_selected == index)
                                              ? Colors.green
                                              : Colors.white
                                          : Colors.grey,
                                      onTap: () {
                                        if (sessions[index].isActive)
                                          setState(() {
                                            _selected = index;
                                          });
                                        else
                                          null;
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Mutation(
                            options: MutationOptions(document: gql(endEvent)),
                            builder: (endEventFun, result) {
                              return TextButton(
                                child: Text("End Event"),
                                onPressed: () {
                                  endEventFun({'eventId': setup.eventDate.id});
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      });
}

calculateActiveSessionOfEvent() {
  for (int i = 0; i < sessions.length; i++) {
    if (sessions[i].isActive) {
      _selected = i;
      break;
    }
  }
}
