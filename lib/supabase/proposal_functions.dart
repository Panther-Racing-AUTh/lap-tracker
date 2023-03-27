import 'package:flutter_complete_guide/models/proposal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Stream<Map<String, Proposal>> getProposals() {
  Map<String, Proposal> m = {};

  return supabase
      .from('v_proposals')
      .stream(primaryKey: ['id'])
      .order('proposal__created_at')
      .map(
        (item) {
          item.forEach((element) {
            if (m.length < 6) {
              if (!m.containsKey(element['user__department'])) {
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

Future changeProposalState({required ProposalState newState}) async {
  var proposalState = await supabase
      .from('proposal_state')
      .update(newState.toJson())
      .eq('id', newState.id)
      .select();
  //await supabase.from('proposal').
}
