class Proposal {
  int id;
  int poolId;
  int partId;
  String partName;
  int partSubsystemId;
  int partCurrentValueId;
  String partMeasurementUnit;
  int partValuesId;
  int partValuesPartId;
  int partValuesValue;
  int userId;
  String userFullName;
  String? userUuid;
  String userRole;
  String userDepartment;
  String title;
  String description;
  String reason;
  String partValueFrom;
  String partValueTo;
  ProposalState state;

  Proposal({
    required this.id,
    required this.poolId,
    required this.partId,
    required this.partName,
    required this.partSubsystemId,
    required this.partCurrentValueId,
    required this.partMeasurementUnit,
    required this.partValuesId,
    required this.partValuesPartId,
    required this.partValuesValue,
    required this.userId,
    required this.userFullName,
    required this.userUuid,
    required this.userRole,
    required this.userDepartment,
    required this.title,
    required this.description,
    required this.reason,
    required this.partValueFrom,
    required this.state,
    required this.partValueTo,
  });

  Proposal.fromJson(Map json, ProposalState this.state)
      : id = json['proposal__id'],
        poolId = json['proposal__proposal_pool_id'],
        partId = json['proposal__part_id'],
        userId = json['proposal__user_id'],
        title = json['proposal__title'],
        description = json['proposal__description'],
        reason = json['proposal__reason'],
        partValueFrom = json['proposal__part_value_from'],
        partValueTo = json['proposal__part_value_to'],
        userFullName = json['user__full_name'],
        userRole = json['user__role'],
        userDepartment = json['user__department'],
        userUuid = json['user__uuid'],
        partName = json['part__name'],
        partSubsystemId = json['part__subsystem_id'],
        partCurrentValueId = json['part__current_value_id'],
        partMeasurementUnit = json['part__measurement_unit'],
        partValuesId = json['part_values__id'],
        partValuesPartId = json['part_values__part_id'],
        partValuesValue = json['part_values__value'];
}

class ProposalState {
  int? id;
  int proposalId;
  int changedByUserId;
  String state;

  ProposalState({
    this.id,
    required this.proposalId,
    required this.changedByUserId,
    required this.state,
  });

  ProposalState.fromJson(Map json)
      : id = json['proposal_state__id'],
        proposalId = json['proposal_state__proposal_id'],
        changedByUserId = json['proposal_state__changed_by_user_id'],
        state = json['proposal_state__state'];

  Map toJson() {
    return {
      'proposal_id': proposalId,
      'changed_by_user_id': changedByUserId,
      'state': state,
    };
  }
}

class ProposalPool {
  int id;
  int sessionId;
  int vehicleId;
  bool ended;

  ProposalPool({
    required this.id,
    required this.sessionId,
    required this.vehicleId,
    required this.ended,
  });

  ProposalPool.fromJson(Map json)
      : id = json['proposal_pool__id'],
        sessionId = json['proposal_pool__session_id'],
        vehicleId = json['proposal_pool__vehicle_id'],
        ended = json['proposal_pool__ended'];
}
