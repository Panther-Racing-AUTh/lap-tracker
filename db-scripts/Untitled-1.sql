
----------------------------------------
--    triggers for proposal system    --
----------------------------------------

DROP TRIGGER IF EXISTS create_proposal_to_tvproposals
ON public.proposal;

-- TRIGGER FROM proposal TO INSERT TO proposal_state THE 'NEW' ENTRY
create or replace function insert__proposal_to_tvproposals()
returns trigger as $$
	begin
        IF (TG_OP='INSERT') THEN
            -- new.id is the new proposal.id we get
            -- new.user_id is the user made the new proposal
            INSERT INTO proposal_state (
                proposal_id,
                changed_by_user_id,
                state
            ) VALUES (
                new.id,
                new.user_id,
                'NEW'
            );
        ELSIF (TG_OP='UPDATE') THEN

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
                AND t_v_proposals.PROPOSAL__created_at = new.created_at;


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
                AND t_v_proposals.PROPOSAL__created_at = new.created_at;

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
                AND new.part_id = pv.part_id;


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
                AND t_v_proposals.PROPOSAL__created_at = new.created_at;


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
                AND t_v_proposals.PROPOSAL__id = new.id;
        ENDIF;

        RETURN NULL;
	end;
$$language plpgsql security definer;

-- trigger the function every time a proposal is created
create trigger create_proposal_to_tvproposals
  AFTER insert or update on public.proposal
  for each row execute procedure public.insert__proposal_to_tvproposals();




----------------------------------------------------------------=====================


DROP TRIGGER IF EXISTS create_new_proposal_state_to_tproposals
ON public.proposal_state;

-- TRIGGER FROM proposal TO INSERT TO t_v_proposal THE UPDATED VALUES
create or replace function insert_updated_proposal_state_to_tvproposals()
returns trigger as $$
	begin

        INSERT INTO t_v_proposals(
            PROPOSAL_STATE__id,
            PROPOSAL_STATE__created_at,
            PROPOSAL_STATE__proposal_id,
            PROPOSAL_STATE__changed_by_user_id,
            PROPOSAL_STATE__state
        ) VALUES (
            new.id,
            new.created_at,
            new.proposal_id,
            new.changed_by_user_id,
            new.state
        );

        -- update t_v_proposals's `proposal` based on (proposal_state) new.id
        UPDATE 
            t_v_proposals
        SET	
            PROPOSAL__id = p.id,
            PROPOSAL__created_at = p.created_at,
            PROPOSAL__proposal_pool_id = p.proposal_pool_id,
            PROPOSAL__part_id = p.part_id,
            PROPOSAL__user_id = p.user_id,
            PROPOSAL__title = p.title,
            PROPOSAL__description = p.description,
            PROPOSAL__reason = p.reason,
            PROPOSAL__json_data = p.json_data,
            PROPOSAL__part_value_from = p.part_value_from,
            PROPOSAL__part_value_to = p.part_value_to
        FROM 
            public.proposal p
        WHERE
            p.id = new.proposal_id
            AND t_v_proposals.PROPOSAL_STATE__created_at = new.created_at;


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
            pp.id = t_v_proposals.PROPOSAL__proposal_pool_id
            AND t_v_proposals.PROPOSAL_STATE__created_at = new.created_at;


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
            p.id = t_v_proposals.PROPOSAL__part_id
            AND t_v_proposals.PROPOSAL_STATE__created_at = new.created_at;

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
            AND t_v_proposals.PROPOSAL_STATE__created_at = new.created_at;


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
            u.id = t_v_proposals.PROPOSAL__user_id
            AND t_v_proposals.PROPOSAL_STATE__created_at = new.created_at;

        RETURN NULL;
	end;
$$language plpgsql security definer;

-- trigger the function every time a proposal is created
create trigger create_new_proposal_state_to_tproposals
  AFTER INSERT on public.proposal_state
  for each row execute procedure public.insert_updated_proposal_state_to_tvproposals();





























-- Create function for table `proposal`
create or replace function insert_whole_proposal_to_tvproposals()
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
				_NEW_#.id,
				_NEW_#.created_at,
				_NEW_#.proposal_pool_id,
				_NEW_#.part_id,
				_NEW_#.user_id,
				_NEW_#.title,
				_NEW_#.description,
				_NEW_#.reason,
				_NEW_#.json_data,
				_NEW_#.part_value_from,
				_NEW_#.part_value_to
			);

			-- update t_v_proposals's `proposal_pool` based on _NEW_#.id
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
				pp.id = _NEW_#.proposal_pool_id
				AND _NEW_#.id = t_v_proposals.PROPOSAL__id;

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
				ps.proposal_id = _NEW_#.id
				AND _NEW_#.id = t_v_proposals.PROPOSAL__id;

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
				p.id = _NEW_#.part_id
				AND _NEW_#.id = t_v_proposals.PROPOSAL__id;

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
				AND _NEW_#.id = t_v_proposals.PROPOSAL__id;


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
				u.id = _NEW_#.user_id
				AND _NEW_#.id = t_v_proposals.PROPOSAL__id;

		ELSIF (TG_OP='UPDATE') THEN

			UPDATE t_v_proposals
			SET	PROPOSAL__created_at = _NEW_#.created_at,
				PROPOSAL__proposal_pool_id = _NEW_#.proposal_pool_id,
				PROPOSAL__part_id = _NEW_#.part_id,
				PROPOSAL__user_id = _NEW_#.user_id,
				PROPOSAL__title = _NEW_#.title,
				PROPOSAL__description = _NEW_#.description,
				PROPOSAL__reason = _NEW_#.reason,
				PROPOSAL__json_data = _NEW_#.json_data,
				PROPOSAL__part_value_from = _NEW_#.part_value_from,
				PROPOSAL__part_value_to = _NEW_#.part_value_to
			WHERE
				t_v_proposals.PROPOSAL__id = _NEW_#.id;

		ELSIF (TG_OP = 'DELETE') THEN
			DELETE FROM
				t_v_proposals
			WHERE
				proposal.PROPOSAL__id = _NEW_#.id;

		END IF;
		RETURN NULL;
	end;
$$language plpgsql security definer;

-- trigger the function every time a user is created
create trigger create_proposal_to_tproposals
  AFTER insert or update on public.proposal
  for each row execute procedure public.insert_whole_proposal_to_tvproposals();

	


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
			PROPOSAL_STATE__id = _NEW_#.id,
			PROPOSAL_STATE__created_at = _NEW_#.created_at,
			PROPOSAL_STATE__proposal_id = _NEW_#.proposal_id,
			PROPOSAL_STATE__changed_by_user_id = _NEW_#.changed_by_user_id,
			PROPOSAL_STATE__state = _NEW_#.state
		FROM 
			public.proposal_state ps
		WHERE 
			t_v_proposals.PROPOSAL__id= _NEW_#.proposal_id
			AND ps.proposal_id = _NEW_#.proposal_id;
		RETURN NULL;
	end;
$$language plpgsql security definer;

-- trigger the function every time a user is created
create trigger update_tvproposals_when_proposal_state_changes_trigger
  AFTER insert on public.proposal_state
  for each row execute procedure public.update_tvproposals_when_proposal_state_changes();