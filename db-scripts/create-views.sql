------------------
-- create views --
------------------

DROP VIEW IF EXISTS v_can_data;
DROP VIEW IF EXISTS v_proposals;

CREATE VIEW v_can_data AS 
  SELECT 
    cd.id as id, ct.timestamp as timestamp, cd.canbus_id as canbus_id, cd.canbus_id_name as canbus_id_name, cd.value as value, cd.unit as unit
  FROM 
    canbus_data cd 
    inner join canbus_timeline ct
      on cd.canbus_timeline_id = ct.id
  ORDER BY cd.id;
	
CREATE VIEW v_proposals AS 
  SELECT 
    p.id as PROPOSAL__id,
    p.created_at as PROPOSAL__created_at,
    p.proposal_pool_id as PROPOSAL__proposal_pool_id,
    p.part_id as PROPOSAL__part_id,
    p.user_id as PROPOSAL__user_id,
    p.title as PROPOSAL__title,
    p.description as PROPOSAL__description,
    p.reason as PROPOSAL__reason,
    p.json_data as PROPOSAL__json_data,
    p.part_value_from as PROPOSAL__part_value_from,
    p.part_value_to	 as PROPOSAL__part_value_to,
    pp.id as PROPOSAL_POOL__id,
    pp.created_at as PROPOSAL_POOL__created_at,
    pp.session_id as PROPOSAL_POOL__session_id,
    pp.vehicle_id as PROPOSAL_POOL__vehicle_id,
    pp.ended as PROPOSAL_POOL__ended,
    ps.id as PROPOSAL_STATE__id,
    ps.created_at as PROPOSAL_STATE__created_at,
    ps.proposal_id as PROPOSAL_STATE__proposal_id,
    ps.changed_by_user_id as PROPOSAL_STATE__changed_by_user_id,
    ps.state as PROPOSAL_STATE__state,
    part.id as PART__id,
    part.created_at as PART__created_at,
    part.name as PART__name,
    part.subsystem_id as PART__subsystem_id,
    part.current_value_id as PART__current_value_id,
    part.measurement_unit as PART__measurement_unit,
    pv.id as PART_VALUES__id,
    pv.created_at as PART_VALUES__created_at,
    pv.part_id as PART_VALUES__part_id,
    pv.value as PART_VALUES__value,
    u.id as USER__id, 
    u.uuid as USER__uuid, 
    u.full_name as USER__full_name, 
    u.role as USER__role, 
    u.department as USER__department
  FROM 
		proposal p
		inner join proposal_pool pp on pp.id = p.proposal_pool_id
		inner join proposal_state ps on ps.proposal_id = p.id
		inner join part on part.id = p.part_id
		inner join part_values pv on part.current_value_id = pv.id
		inner join users u on p.user_id = u.id
  ORDER BY p.created_at;
