import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/app_setup.dart';
import 'package:flutter_complete_guide/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/proposal.dart';
import '../../supabase/proposal_functions.dart';

class HandsOnScreen extends StatefulWidget {
  const HandsOnScreen({super.key});
//

  @override
  State<HandsOnScreen> createState() => _HandsOnScreenState();
}

List<bool> checks = [];
List<Proposal> healthChecks = [];
String global = '';

class _HandsOnScreenState extends State<HandsOnScreen> {
  void checked(ProposalState newState, Proposal proposal, bool affectPart) {
    // // print('checked');
    // // print('newState.state : ' + newState.state);
    setState(() {
      changeProposalState(
          newState: newState, proposal: proposal, affectPart: affectPart);
    });
  }

  @override
  void initState() {
    print('constructed hands on screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Subscription(
      options: SubscriptionOptions(
        document: gql(getApprovedProposals),
      ),
      builder: (result) {
        if (result.hasException) {
          print(result.exception);
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }

        tasks = [];
        healthChecks = [];

        String tabs =
            '\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}\u{2007}';

        List<Proposal> incomingProposals = [];
        // print(result.data!['proposal_pool']);
        // print(result.data!['proposal_pool'][0]);
        // print(result.data!['proposal_pool'][0]['proposals']);
        // print(result.data!['proposal_pool'][0]['proposals'][0]);
        // print('=============================');
        print(result.data);
        for (var proposal in result.data!['proposal_pool'][0]['proposals']) {
          if (proposal['proposal_states'][0]['state'] == 'APPROVED' ||
              proposal['proposal_states'][0]['state'] == 'DONE' &&
                  proposal['user_id'] != null)
            incomingProposals.add(Proposal.fromJson(proposal,
                ProposalState.fromJson(proposal['proposal_states'][0])));
        }
        print(result.data!['proposal_pool'][0]['proposals']);
        print(healthChecks);
        for (var proposal in result.data!['proposal_pool'][0]['proposals']) {
          print(proposal);
          if (proposal['user_id'] == null)
            healthChecks.add(
              Proposal.fromJson(
                proposal,
                ProposalState.fromJson(proposal['proposal_states'][0]),
                isHealthCheck: true,
              ),
            );
        }
        print(healthChecks);
        // late Proposal proposal;
        // // // print('snapshot.data' + snapshot.data.toString());
        incomingProposals.forEach((prop) {
          // // print('\nprop.Id:\t\t' + prop.id.toString());
          // // print('prop.proposalId:\t' + prop.proposalId.toString());
          MapEntry<int, MapEntry<int, String>> oldTask =
              MapEntry<int, MapEntry<int, String>>(
                  0, MapEntry<int, String>(0, ''));

          // print('prop.proposalId' + prop.proposalId.toString());
          bool existingProposal =
              tasks.any((task) => task.key == prop.proposalId);
          // print('existingProposal' + existingProposal.toString());

          try {
            if (existingProposal) {
              oldTask = tasks.firstWhere((p) => p.key == prop.proposalId);
              // print('\toldTask:\t' + oldTask.toString());
            }
          } catch (e) {
            // // print(e);
          }

          if (existingProposal && oldTask.key < (prop.proposalId ?? 0)) {
            // print('\tupdate existing task with id: ' + oldTask.key.toString() + '\tto: ' + prop.proposalId.toString());
            int indexToUpdate =
                tasks.indexWhere((task) => task.key == prop.proposalId);

            tasks[indexToUpdate] = MapEntry(
                prop.proposalId ?? -1,
                MapEntry(
                    prop.id ?? -1, prop.title + tabs + (prop.description)));
            // print('\ttasks[indexToUpdate]' + tasks[indexToUpdate].toString());
            // if old task has the same  id OR smaller do not update
          } else if (!existingProposal) {
            // print('\tinsert new task with id: ' + prop.proposalId.toString());
            tasks.insert(
                0,
                MapEntry(
                    prop.proposalId ?? 0,
                    MapEntry(prop.id ?? -1,
                        prop.title + tabs + (prop.description))));
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
        print('&&&&&&&&&&&&&&&&&&&&&');
        print(tasks);
        print(incomingProposals);
        print(healthChecks);
        print(healthChecks[0].state!.state);
        return SingleChildScrollView(
          child: Column(
            // shrinkWrap: true,
            children: [
              ListTile(
                title: Text('Health Checks'),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: healthChecks.length,
                itemBuilder: (context, index) {
                  return CustomListTile(
                    id: index + 1,
                    task: healthChecks[index].title,
                    proposal: healthChecks[index],
                    completed: checked,
                    isHealthCheck: true,
                  );
                  // sendTaskComplete: sendTaskComplete);
                },
              ),
              ListTile(
                title: Text('Tasks'),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: incomingProposals.length,
                itemBuilder: ((context, index) {
                  Proposal prop = incomingProposals[index];
                  print(prop.id);
                  print(prop.state!.state);
                  // prop.proposalId = tasks[index].key;
                  // prop.state!.proposalId = tasks[index].key;

                  // // // print('\nindex');
                  // // // print(index);
                  // // // print(tasks[index].value.value);
                  // // // print(prop.toJson());
                  // // // print('\n');
                  // // // print(incomingProposals[index].toJson());
                  // // // print('\n');

                  return CustomListTile(
                    id: index + 1,
                    task: prop.title,
                    completed: checked,
                    proposal: prop,
                  );
                  // sendTaskComplete: sendTaskComplete);
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomListTile extends StatefulWidget {
  CustomListTile({
    required int this.id,
    required String this.task,
    required Function(ProposalState, Proposal, bool) this.completed,
    Proposal? this.proposal,
    this.isHealthCheck = false,
  });

  int id;
  String task;
  Function(ProposalState, Proposal, bool) completed;
  Proposal? proposal;
  bool isHealthCheck;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    AppSetup setup = Provider.of<AppSetup>(context);
    return ListTile(
      tileColor:
          widget.proposal!.state!.state == 'DONE' ? Colors.green : Colors.white,
      // tileColor: checks[id -1] ? Colors.green : Colors.white,
      leading: Text(widget.id.toString()),
      title: RichText(
        text: TextSpan(
          text: widget.task,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          if (!widget.isHealthCheck) {
            widget.completed(
              ProposalState(
                proposalId: widget.proposal!.proposalId,
                changedByUserId: setup.supabase_id, //hands on team id
                state: 'DONE',
              ),
              widget.proposal!,
              true,
            );
          } else {
            widget.completed(
              ProposalState(
                proposalId: widget.proposal!.proposalId,
                changedByUserId: setup.supabase_id,
                state: 'DONE',
              ),
              widget.proposal!,
              false,
            );
          }
          print('Health Check done.');
        },
        child: Text('DONE'),
      ),
    );
  }
}

//List<Map<proposal__id(65), Map<id(201), proposalDescription.randomString>>>
List<MapEntry<int, MapEntry<int, String>>> tasks = [];
