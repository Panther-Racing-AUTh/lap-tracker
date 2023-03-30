import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Stream<Map<String, Proposal>> getProposals() {
  int x = 0;
  return supabase
      .from('t_v_proposals')
      .stream(primaryKey: ['id'])
      .order('id')
      .limit(1)
      .map(
        (item) {
          Map<String, Proposal> m = {};
          x++;
          print('x = ' + x.toString());
          print('${item.length} rows were fetched');
          item.forEach((element) {
            print('a row was parsed');
            if (m.length < 6) {
              if (!m.containsKey(element['user__department']) &&
                  element['user__department'] != 'department') {
                m[element['user__department']] =
                    Proposal.fromJson(element, ProposalState.fromJson(element));
              }
            }
          });

          return m;
        },
      );
  //print(proposals.first);
}

Future getproposals() async {
  final proposals = await supabase.from('t_v_proposals').select().order('id');
}

Future changeProposalState({required ProposalState newState}) async {
  var proposalState =
      await supabase.from('proposal_state').insert(newState.toJson()).select();
}

Future sendProposal({required Proposal proposal}) async {
  await supabase.from('proposal').insert(proposal.toJson());
}
