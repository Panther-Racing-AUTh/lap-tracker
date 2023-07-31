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
          List<int> t_v_proposalds = [];

          item.forEach((element) {
            if (t_v_proposalds.contains(element['id'])) return;

            t_v_proposalds.add(element['id']);

            print(
                'proposal_state__state:\t' + element['proposal_state__state']);
            if (element['proposal_state__state'] == 'DONE' ||
                element['proposal_state__state'] == 'APPROVED') {
              print('\tIF');
              print(element);
              m.add(
                  Proposal.fromJson(element, ProposalState.fromJson(element)));
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
  //print(proposal.);
  await supabase.from('proposal').insert(proposal.toJson());
}

Future updateProposal({required Proposal proposal}) async {
  await supabase
      .from('proposal')
      .update(proposal.toJson())
      .match({'id': proposal.id});
}

Future taskDone({required ProposalState newState}) async {
  print('taskDone: proposal_state');

  var proposalState =
      await supabase.from('proposal_state').insert(newState.toJson()).select();
  print(proposalState);
}

Future<List<ProposalPool>> getProposalsForSession(
    {required int sessionId}) async {
  List<ProposalPool> proposalPools = [];
  final proposalPoolsIds = [];
  final proposals = [];
  final proposalsIds = [];
  final proposalStates = [];

  final proposalPoolsJson = await supabase
      .from('proposal_pool')
      .select()
      .eq('session_id', sessionId)
      .order('id');

  for (var proposal in proposalPoolsJson) {
    proposalPools.add(ProposalPool.fromJson(proposal));
    proposalPoolsIds.add(proposal['id']);
  }

  final proposalsJson = await supabase
      .from('proposal')
      .select()
      .in_('proposal_pool_id', proposalPoolsIds)
      .order('id');

  for (var proposal in proposalsJson) {
    proposalsIds.add(proposal['id']);
  }

  final proposalStatesJson = await supabase
      .from('proposal_state')
      .select()
      .in_('proposal_id', proposalsIds)
      .order('id');

  for (var proposalState in proposalStatesJson) {
    proposalStates.add(ProposalState.fromJson(proposalState));
  }
  for (var proposal in proposalsJson) {
    ProposalState s = proposalStates.firstWhere((state) {
      return state.proposalId == proposal['id'];
    }, orElse: () => ProposalState.empty());
    proposals.add(Proposal.fromJson(proposal, s));
  }

  for (int i = 0; i < proposals.length; i++) {
    for (int j = 0; j < proposalStates.length; j++) {
      if (proposals[i].id == proposalStates[j].proposalId)
        proposals[i].states.add(proposalStates[j]);
    }
  }

  for (var proposalPool in proposalPools) {
    for (var proposal in proposals) {
      if (proposal.poolId == proposalPool.id)
        proposalPool.proposals.add(proposal);
    }
  }

  return proposalPools;
}
