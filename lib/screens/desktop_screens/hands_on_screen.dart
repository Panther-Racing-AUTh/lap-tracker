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
    setState(() {
      changeProposalState(newState: newState);
    });
  }

  void sendTaskComplete() {
    setState(() {
      sendProposal(
        proposal: Proposal(
          partId: 103,
          partName: 'partName',
          partMeasurementUnit: 'partMeasurementUnit',
          userId: Provider.of<AppSetup>(context, listen: false).supabase_id,
          userRole: 'userRole',
          userDepartment: 'Hands-On',
          title: global,
          description: 'description',
          reason: 'reason',
          partValueFrom: 'partValueFrom',
          partValueTo: 'partValueTo',
        ),
      );
    });
  }

  final _handsOnStream = handsOnStream();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Proposal>>(
      stream: _handsOnStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          late Proposal proposal;
          if (snapshot.data!.isNotEmpty)
            proposal = snapshot.data![0];
          else
            proposal = Proposal.empty();
          if (!tasks.contains(proposal.description) && proposal.title != '')
            tasks.insert(0, proposal.title);

          for (int i = 0; i < tasks.length; i++) {
            checks.add(false);
          }
          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: ((context, index) {
                return customListTile(
                    id: index + 1,
                    task: tasks[index],
                    completed: checked,
                    p: proposal,
                    sendTaskComplete: sendTaskComplete);
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
  required Proposal p,
  required Function sendTaskComplete,
}) =>
    ListTile(
      tileColor: checks[id - 1] ? Colors.green : Colors.white,
      leading: Text(id.toString()),
      title: Text(task),
      trailing: ElevatedButton(
          onPressed: () {
            checks[id - 1] = true;
            (id == 0 && tasks.length > 1)
                ? completed(
                    ProposalState(
                      id: p.state!.id,
                      proposalId: p.id!,
                      changedByUserId: 1,
                      state: 'DONE',
                    ),
                  )
                : sendTaskComplete();
          },
          child: Text('DONE')),
    );

List tasks = [
  'All Standard checks completed successfully',
];
