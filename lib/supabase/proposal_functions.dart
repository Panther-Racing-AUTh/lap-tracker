import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Stream<Map<String, Proposal>> getProposals() {
  return supabase
      .from('t_v_proposals')
      .stream(primaryKey: ['id'])
      .order('id')
      .map(
        (item) {
          Map<String, Proposal> m = {};

          item.forEach((element) {
            if (element.length == 1) return;

            if (m.length < 6) {
              if (!m.containsKey(element['user__department']) &&
                  element['user__department'] != 'department') {
                if (element['user__role'] == 'Hands-On Engineer') {
                  m['hands_on'] = Proposal.fromJson(
                      element, ProposalState.fromJson(element));
                } else {
                  m[element['user__department']] = Proposal.fromJson(
                      element, ProposalState.fromJson(element));
                }
              }
            }
          });

          return m;
        },
      );
  //print(proposals.first);
}

Stream<List<Proposal>> handsOnStream() {
  return supabase
      .from('t_v_proposals')
      .stream(primaryKey: ['id'])
      .order('id')
      .map(
        (item) {
          List<Proposal> m = [];
          List<int> t_v_proposalds= [];

          item.forEach((element) {
            if (t_v_proposalds.contains(element['id'])) 
              return;
            
            t_v_proposalds.add(element['id']);

            print('proposal_state__state:\t' + element['proposal_state__state']);
            if(element['proposal_state__state'] == 'DONE' 
              || element['proposal_state__state'] == 'APPROVED' ) {
                print('\tIF');
                print(element);
                m.add(Proposal.fromJson(element, ProposalState.fromJson(element)));
                print('\tEND IF');
                print('new proposal:\0t' + m.last.toJson().toString());
              }
          });
          print('\n\n\n m size : \t' + m.length.toString());
          print(m);
          return m;
        },
      );
  //print(proposals.first);
}

Future getproposals() async {
  print('getproposals: t_v_proposals');
  final proposals = await supabase.from('t_v_proposals').select().order('id');
}

Future changeProposalState({required ProposalState newState}) async {
  print('changeProposalState: proposal_state\t' + newState.toJson().toString());
  Map<String, dynamic> stateReq = {
         'proposal_id': newState.proposalId,
         'changed_by_user_id': newState.changedByUserId,
         'state': newState.state,
  };
  print(stateReq);
  var proposalState =
      await supabase.from('proposal_state').insert(stateReq).select();
}

Future sendProposal({required Proposal proposal}) async {
  print('sendProposal: proposal');
  await supabase.from('proposal').insert(proposal.toJson());
}

Future taskDone({required ProposalState newState}) async {
  print('taskDone: proposal_state');

  var proposalState =
      await supabase.from('proposal_state').insert(newState.toJson()).select();
  print(proposalState);
}
