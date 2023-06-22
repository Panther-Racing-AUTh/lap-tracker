import 'package:flutter/material.dart';

class Proposal {
  int? id;
  int? proposalId;
  String? proposalCreatedAt;
  String? proposalProposalPoolId;
  String? proposalPartId;
  String? proposalUserId;
  String? proposalTitle;
  String? proposalDescription;
  String? proposalReason;
  String? proposalJsonData;
  String? proposalPartValueFrom;
  String? proposalPartValueTo;
  int? poolId;
  int? partId;
  String? partName;
  int? partSubsystemId;
  int? partCurrentValueId;
  String? partMeasurementUnit;
  int? partValuesId;
  int? partValuesPartId;
  int? partValuesValue;
  int userId;
  String? userFullName;
  String? userUuid;
  String? userRole;
  String? userDepartment;
  String title;
  String description;
  String reason;
  String partValueFrom;
  String partValueTo;
  ProposalState? state;

  Proposal.empty()
      : description = '',
        partId = 0,
        partMeasurementUnit = '',
        partName = '',
        partValueFrom = '',
        partValueTo = '',
        reason = '',
        title = '',
        userDepartment = '',
        userId = 0,
        userRole = '',
        state = ProposalState.empty();

  Proposal({
    this.proposalCreatedAt,
    this.proposalProposalPoolId,
    this.proposalPartId,
    this.proposalUserId,
    this.proposalTitle,
    this.proposalDescription,
    this.proposalReason,
    this.proposalJsonData,
    this.proposalPartValueFrom,
    this.proposalPartValueTo,
    this.id,
    this.poolId,
    required this.partId,
    required this.partName,
    this.partSubsystemId,
    this.partCurrentValueId,
    required this.partMeasurementUnit,
    this.partValuesId,
    this.partValuesPartId,
    this.partValuesValue,
    required this.userId,
    this.userFullName,
    this.userUuid,
    required this.userRole,
    required this.userDepartment,
    required this.title,
    required this.description,
    required this.reason,
    required this.partValueFrom,
    this.state,
    required this.partValueTo,
  });

  Proposal.fromJson(Map json, ProposalState this.state)
      : id = json['id'], // 201 -> 202
        proposalId = json['id'], //65
        proposalCreatedAt = json['created_at'] ?? null, //65
        poolId = json['proposal_pool_id'] ?? null,
        partId = json['part_id'] ?? null,
        userId = json['user_id'] ?? null,
        title = json['title'] ?? null,
        description = json['description'] == null ? '' : json['description'],
        reason = json['reason'] == null ? '' : json['reason'],
        partValueFrom = json['part_value_from'] ?? null,
        partValueTo = json['part_value_to'] ?? null;
  //userFullName = json['user__full_name'],
  //userRole = json['user__role'],
  //userDepartment = json['user__department'],
  //userUuid = json['user__uuid'],
  //partName = json['part__name'],
  //partSubsystemId = json['part__subsystem_id'],
  //partCurrentValueId = json['part__current_value_id'],
  //partMeasurementUnit = json['part__measurement_unit'],
  //partValuesId = json['part_values__id'],
  //partValuesPartId = json['part_values__part_id'],
  //partValuesValue = json['part_values__value'];

  Map toJson() {
    return {
      'proposal_pool_id': poolId,
      'part_id': partId,
      'user_id': userId,
      'title': title,
      'description': description,
      'reason': reason,
      'part_value_from': partValueFrom,
      'part_value_to': partValueTo,
      //'json_data':
    };
  }
}

class ProposalState {
  int? id;
  int? proposalId;
  int changedByUserId;
  String state;

  ProposalState({
    this.id,
    required this.proposalId,
    required this.changedByUserId,
    required this.state,
  });

  ProposalState.empty()
      : changedByUserId = 0,
        proposalId = 0,
        state = 'default state';

  ProposalState.fromJson(Map json)
      : id = json['id'],
        proposalId = json['proposal_id'],
        changedByUserId = json['changed_by_user_id'],
        state = json['state'];

  Map toJson() {
    return {
      'proposalId': proposalId,
      'changedByUserId': changedByUserId,
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
