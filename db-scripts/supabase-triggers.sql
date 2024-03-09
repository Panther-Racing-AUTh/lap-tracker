----------------------------------------
--the two essential triggers for users--
----------------------------------------

-- the function that can copy the users from auth
create or replace function public.handle_new_user() 
returns trigger as $$
	begin
		insert into public.users (uuid, email, full_name)
		values (new.id, new.email, new.raw_user_meta_data->>'full_name');
		return new;
	end;
$$ language plpgsql security definer;

-- the function that assigns role to user right after creation
create or replace function public.handle_new_user2()
returns trigger as $$
	begin
		insert into public.user_roles (user_id, role_id)
		values (new.id, 4);
		return new;
	end;
$$ language plpgsql security definer;

-- trigger the function every time a user is created
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
  after insert on public.users
  for each row execute procedure public.handle_new_user2();

----------------------------------------
--    triggers for proposal system    --
----------------------------------------
DROP TRIGGER IF EXISTS create_proposal_to_tproposals
ON public.proposal;

-- Create function for table `proposal`
create or replace function insert_proposal_to_tproposals()
returns trigger as $$
	begin
		IF (TG_OP='INSERT') THEN
		
			-- insert to t_v_proposals
			INSERT INTO t_v_proposals(
				PROPOSAL__id,
				PROPOSAL__created_at,
				PROPOSAL__proposal_pool_id,
				PROPOSAL__part_id,
				PROPOSAL__user_id,
				PROPOSAL__title,
				PROPOSAL__description,
				PROPOSAL__reason,
				PROPOSAL__json_data,
				PROPOSAL__part_value_from,
				PROPOSAL__part_value_to
			) VALUES (
				new.id,
				new.created_at,
				new.proposal_pool_id,
				new.part_id,
				new.user_id,
				new.title,
				new.description,
				new.reason,
				new.json_data,
				new.part_value_from,
				new.part_value_to
			);

			-- update t_v_proposals's `proposal_pool` based on new.id
			UPDATE 
				t_v_proposals
			SET	
				PROPOSAL_POOL__id = pp.id,
				PROPOSAL_POOL__created_at = pp.created_at,
				PROPOSAL_POOL__session_id = pp.session_id,
				PROPOSAL_POOL__vehicle_id = pp.vehicle_id,
				PROPOSAL_POOL__ended = pp.ended
			FROM 
				public.proposal_pool pp
			WHERE
				pp.id = new.proposal_pool_id
				AND new.id = t_v_proposals.PROPOSAL__id;

			-- update t_v_proposals's `proposal_state` based on proposal_state.proposal_id
			UPDATE 
				t_v_proposals
			SET	
				PROPOSAL_STATE__id = ps.id,
				PROPOSAL_STATE__created_at = ps.created_at,
				PROPOSAL_STATE__proposal_id = ps.proposal_id,
				PROPOSAL_STATE__changed_by_user_id = ps.changed_by_user_id,
				PROPOSAL_STATE__state = ps.state
			FROM 
				public.proposal_state ps
			WHERE
				ps.proposal_id = new.id
				AND new.id = t_v_proposals.PROPOSAL__id;

			-- update t_v_proposals's `part` based on part.id
			UPDATE 
				t_v_proposals
			SET	
				PART__id = p.id,
				PART__created_at = p.created_at,
				PART__name = p.name,
				PART__subsystem_id = p.subsystem_id,
				PART__current_value_id = p.current_value_id,
				PART__measurement_unit = p.measurement_unit
			FROM 
				public.part p
			WHERE
				p.id = new.part_id
				AND new.id = t_v_proposals.PROPOSAL__id;

			-- update t_v_proposals's `part_values` based on part_values.part_id
			UPDATE 
				t_v_proposals
			SET	
				PART_VALUES__id = pv.id,
				PART_VALUES__created_at = pv.created_at,
				PART_VALUES__part_id = pv.part_id,
				PART_VALUES__value = pv.value
			FROM 
				public.part_values pv
			WHERE
				pv.part_id = t_v_proposals.PART__id
				AND new.id = t_v_proposals.PROPOSAL__id;


			-- update t_v_proposals's `users` based on users.id
			UPDATE 
				t_v_proposals
			SET	
				USER__id = u.id,
				USER__uuid = u.uuid,
				USER__full_name = u.full_name,
				USER__role = u.role,
				USER__department = u.department
			FROM 
				public.users u
			WHERE
				u.id = new.user_id
				AND new.id = t_v_proposals.PROPOSAL__id;

		ELSIF (TG_OP='UPDATE') THEN

			UPDATE t_v_proposals
			SET	PROPOSAL__created_at = new.created_at,
				PROPOSAL__proposal_pool_id = new.proposal_pool_id,
				PROPOSAL__part_id = new.part_id,
				PROPOSAL__user_id = new.user_id,
				PROPOSAL__title = new.title,
				PROPOSAL__description = new.description,
				PROPOSAL__reason = new.reason,
				PROPOSAL__json_data = new.json_data,
				PROPOSAL__part_value_from = new.part_value_from,
				PROPOSAL__part_value_to = new.part_value_to
			WHERE
				t_v_proposals.PROPOSAL__id = new.id;

		ELSIF (TG_OP = 'DELETE') THEN
			DELETE FROM
				t_v_proposals
			WHERE
				proposal.PROPOSAL__id = new.id;

		END IF;
		RETURN NULL;
	end;
$$language plpgsql security definer;

-- trigger the function every time a user is created
create trigger create_proposal_to_tproposals
  AFTER insert or update or delete on public.proposal
  for each row execute procedure public.insert_proposal_to_tproposals();

	


----------------------------------------
--    triggers for proposal states    --
----------------------------------------

DROP TRIGGER IF EXISTS update_tvproposals_when_proposal_state_changes_trigger
ON public.proposal_state;

-- Create function for table `proposal`
create or replace function update_tvproposals_when_proposal_state_changes()
returns trigger as $$
	begin
		-- update t_v_proposals's `proposal_state` based on proposal_state.proposal_id
		UPDATE 
			t_v_proposals
		SET	
			PROPOSAL_STATE__id = new.id,
			PROPOSAL_STATE__created_at = new.created_at,
			PROPOSAL_STATE__proposal_id = new.proposal_id,
			PROPOSAL_STATE__changed_by_user_id = new.changed_by_user_id,
			PROPOSAL_STATE__state = new.state
		FROM 
			public.proposal_state ps
		WHERE 
			t_v_proposals.PROPOSAL__id= new.proposal_id
			AND ps.proposal_id = new.proposal_id;
		RETURN NULL;
	end;
$$language plpgsql security definer;

-- trigger the function every time a user is created
create trigger update_tvproposals_when_proposal_state_changes_trigger
  AFTER insert on public.proposal_state
  for each row execute procedure public.update_tvproposals_when_proposal_state_changes();