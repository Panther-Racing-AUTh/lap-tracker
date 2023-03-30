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
          List departments = [];
          item.forEach((element) {
            if (element.length == 1) return;

            if (element['user__department'] != 'department' &&
                (element['proposal_state__state'] == 'APPROVED') &&
                !departments.contains(element['user__department'])) {
              departments.add(element['user__department']);
              m.add(
                  Proposal.fromJson(element, ProposalState.fromJson(element)));
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

Future taskDone({required ProposalState newState}) async {
  var proposalState =
      await supabase.from('proposal_state').insert(newState.toJson()).select();
  print(proposalState);
}
