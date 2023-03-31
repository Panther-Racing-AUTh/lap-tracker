import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:provider/provider.dart';

import '../../models/proposal.dart';
import '../../supabase/proposal_functions.dart';

class HandsOnScreen extends StatefulWidget {
  const HandsOnScreen({super.key});

  @override
  State<HandsOnScreen> createState() => _HandsOnScreenState();
}

List<bool> checks = [];

String global = '';

class _HandsOnScreenState extends State<HandsOnScreen> {
  void checked(ProposalState newState) {
    // // print('checked');
    // // print('newState.state : ' + newState.state);
    setState(() {
      changeProposalState(newState: newState);
    });

  }

  final _handsOnStream = handsOnStream();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Proposal>>(
      stream: _handsOnStream,
      builder: (context, snapshot) {
        // // print('snapshot.hasData : ' + snapshot.hasData.toString());
        // initialize tasks before each build 
        // task is an external global variable that has to be set
        // to its initial value every time the builder is called
        //List<Map<proposal__id(65), Map<id(201), proposalDescription.randomString>>>

        tasks =  [];

        String tabs = '\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}';
        if (snapshot.hasData) {
          List<Proposal> incomingProposals = snapshot.data ?? [];
          // late Proposal proposal;
          // // // print('snapshot.data' + snapshot.data.toString());
          incomingProposals.forEach((prop) {
            // // print('\nprop.Id:\t\t' + prop.id.toString());
            // // print('prop.proposalId:\t' + prop.proposalId.toString());
            MapEntry<int, MapEntry<int, String>> oldTask = MapEntry<int, MapEntry<int, String>>(0, MapEntry<int, String>(0,''));

            // print('prop.proposalId' + prop.proposalId.toString());
            bool existingProposal = tasks.any((task) => task.key == prop.proposalId);
            // print('existingProposal' + existingProposal.toString());

            try {
              if (existingProposal) {
                oldTask = tasks.firstWhere((p) => p.key == prop.proposalId);
                // print('\toldTask:\t' + oldTask.toString());
              }
            } catch (e) {
              // // print(e);
            }

            if(existingProposal && oldTask.key < (prop.proposalId ?? 0)) {
              // print('\tupdate existing task with id: ' + oldTask.key.toString() + '\tto: ' + prop.proposalId.toString());
              int indexToUpdate = tasks.indexWhere((task) => task.key == prop.proposalId);

              tasks[indexToUpdate] = 
                    MapEntry(
                      prop.proposalId ?? -1, 
                      MapEntry(
                        prop.id ?? -1,
                        prop.title + tabs + (prop.description)
                      )
                    );
              // print('\ttasks[indexToUpdate]' + tasks[indexToUpdate].toString());
              // if old task has the same  id OR smaller do not update
              
            } else if (!existingProposal) {
              // print('\tinsert new task with id: ' + prop.proposalId.toString());
              tasks.insert(0, 
                MapEntry(
                  prop.proposalId ?? 0, 
                  MapEntry(
                      prop.id ?? -1,
                      prop.title + tabs + (prop.description)
                    )
                )
              );
            } else {
              // print('\tNo updates at all');
            }

          });

          // print('\n\n\n\n\ntasks');
          // print(tasks);

          // // // print('\n\n\ttasks:'+ tasks[0].key.toString() + "\t" +  tasks[0].value.toString());

          // for (int i = 0; i < tasks.length; i++) {
          //   checks.add(false);
          // }
          // // // print('tasks.length : ' + tasks.length.toString());
          // // // print('proposal : ' + tasks.toString());
          
          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: ((context, index) {
                Proposal prop = incomingProposals[index];
                prop.proposalId = tasks[index].key;
                prop.state!.proposalId = tasks[index].key;

                // // // print('\nindex');
                // // // print(index);
                // // // print(tasks[index].value.value);
                // // // print(prop.toJson());
                // // // print('\n');
                // // // print(incomingProposals[index].toJson());
                // // // print('\n');

                return customListTile(
                    id: index + 1,
                    task: tasks[index].value.value,
                    completed: checked,
                    proposal: prop);
                    // sendTaskComplete: sendTaskComplete);
              }));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

Widget customListTile({
  required int id,
  required String task,
  required Function(ProposalState) completed,
  required Proposal? proposal,
  // required Function sendTaskComplete,
}) =>
    ListTile(
      tileColor: proposal!.state!.state == 'DONE' ? Colors.green : Colors.white,
      // tileColor: checks[id -1] ? Colors.green : Colors.white,
      leading: Text(id.toString()),
      title: RichText(text:
              TextSpan(
                text: task,
                style: TextStyle(fontSize: 20)
              )
            ),
      trailing: ElevatedButton(
          onPressed: () {
            // print('ListTile - onPressed\n');
            // print(proposal.state!.state);
            // print(proposal.state!.toJson());
            completed(
                    ProposalState(
                      proposalId: proposal.proposalId,
                      changedByUserId: 26, //hands on team id
                      state: 'DONE',
                    )
            );
          },
          child: Text('DONE')),
    );


//List<Map<proposal__id(65), Map<id(201), proposalDescription.randomString>>>
List<MapEntry<int, MapEntry<int, String>>> tasks = [];
