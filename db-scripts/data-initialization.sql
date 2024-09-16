----------------------------------------
-- initialization of the Database Data--
----------------------------------------

INSERT INTO roles(role, description)
VALUES 
('admin', 'This is the admin role. An admin has access to all users and their roles and all features of the application.'),
('engineer','This is the engineer role. It is the standard role and unlocks all features of the application.'),
('data_analyst','This is the data analyst role. This role has only access to data from previous sessions.'),
('default','This is the default role. This role has no rights in the application.'),
('member', 'This is the member role, It is the standard role and unlocks all the basic features of the application.'),
('coordinator', 'This is the coordinator role. This role has special access on some occasions.');
-- set the default user as the default id at user creation at user_roles
ALTER TABLE user_roles
ALTER COLUMN role_id SET DEFAULT 4;

INSERT INTO users (uuid, email, password, provider, created_at, full_name, about, role, department, active)
VALUES (null, 'admin', 'admin', 'panther', NOW(), 'administrator', 'Panther s Administrator', 'Engineer','electronics', true),
(null, 'engineer', 'engineer', 'panther', NOW(), 'engineer', 'Panther s engineer', 'Engineer','electronics', true),
(null, 'data', 'data', 'data_analyst', NOW(), 'data_analyst', 'Panther s Data Analyst', 'Engineer','frame', true),
(null, 'default', 'default', 'default', NOW(), 'default', 'Panther s Default User', 'No role','department', true);

INSERT INTO user_roles (user_id, role_id)
VALUES (1, 1),
(2,2),
(3,3),
(4,4);

INSERT INTO event_date(date, description)
VALUES (NOW(), 'Finals');
INSERT INTO racetrack(name, country, country_code)
VALUES ('Aragon', 'Spain', 'es');
INSERT INTO session(racetrack_id, session_order, type, event_date_id)
VALUES (1, '1', 'practice', 1);
INSERT INTO lap(session_id, lap_order)
VALUES (1, 1);


-------------
-- vehicle --
-------------

INSERT INTO vehicle (name, year, description)
VALUES ('Panthera Pardus', '2017-2018', 'Our 1st prototype for MotoStudent V @ Panther Racing AUTh');
INSERT INTO vehicle (name, year, description)
VALUES ('Black Panther', '2019-2021', 'Our 2nd prototype for MotoStudent VI @ Panther Racing AUTh');

INSERT INTO system(name, vehicle_id, description)
SELECT 'Vehicle Geometry', v.id, 'General System of Vehicle Geometry' FROM vehicle v WHERE v.name='Black Panther';
INSERT INTO system(name, vehicle_id, description)
SELECT 'Electronics', v.id, 'General System of Electronics' FROM vehicle v WHERE v.name='Black Panther';
INSERT INTO system(name, vehicle_id, description)
SELECT 'Suspension', v.id, 'General System of Suspension' FROM vehicle v WHERE v.name='Black Panther';

INSERT INTO subsystem(name, system_id, description)
SELECT 'Geometry setups', s.id, 'Subsystem of Vehicle Geometry' FROM system s WHERE s.name='Vehicle Geometry';
INSERT INTO subsystem(name, system_id, description)
SELECT 'Electronic Control Unit', s.id, 'Subsystem of Electronics' FROM system s WHERE s.name='Electronics';
INSERT INTO subsystem(name, system_id, description)
SELECT 'Front Suspension', s.id, 'Subsystem of Suspension' FROM system s WHERE s.name='Suspension';
INSERT INTO subsystem(name, system_id, description)
SELECT 'Rear Signle Shock Absorber', s.id, 'Subsystem of Suspension' FROM system s WHERE s.name='Suspension';

INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Steering Head inclination', ss.id, 'Degrees' FROM subsystem ss WHERE ss.name='Geometry setups';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Trail', ss.id, 'cm' FROM subsystem ss WHERE ss.name='Geometry setups';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Steering plate position', ss.id, 'cm' FROM subsystem ss WHERE ss.name='Geometry setups';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Rear swingarm length', ss.id, 'cm' FROM subsystem ss WHERE ss.name='Geometry setups';

INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Traction Control', ss.id, 'numeric' FROM subsystem ss WHERE ss.name='Electronic Control Unit';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Engine Break', ss.id, 'bhp' FROM subsystem ss WHERE ss.name='Electronic Control Unit';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Power Mapping', ss.id, 'numeric' FROM subsystem ss WHERE ss.name='Electronic Control Unit';

INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Front Pre-load', ss.id, 'centimeters' FROM subsystem ss WHERE ss.name='Front Suspension';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Oil quantity', ss.id, 'centistokes' FROM subsystem ss WHERE ss.name='Front Suspension';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Front spring hardness', ss.id, 'centimeters' FROM subsystem ss WHERE ss.name='Front Suspension';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Front swingarm compression', ss.id, 'Newtons ' FROM subsystem ss WHERE ss.name='Front Suspension';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Front swingarm extension', ss.id, 'Newtons ' FROM subsystem ss WHERE ss.name='Front Suspension';

INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Rear Pre-load', ss.id, 'centimeters ' FROM subsystem ss WHERE ss.name='Rear Signle Shock Absorber';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Swingarm connector', ss.id, 'centimeters ' FROM subsystem ss WHERE ss.name='Rear Signle Shock Absorber';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Signle Shock Absorber extension', ss.id, 'Newtons ' FROM subsystem ss WHERE ss.name='Rear Signle Shock Absorber';
INSERT INTO part (name, subsystem_id, measurement_unit)
SELECT 'Signle Shock Absorber extension', ss.id, 'Newtons ' FROM subsystem ss WHERE ss.name='Rear Signle Shock Absorber';

-- some more inserts at this point for part_values

---------------
-- proposals --
---------------

INSERT INTO proposal_pool(session_id, vehicle_id)
SELECT 1, v.id FROM vehicle v WHERE v.name='Black Panther';

INSERT INTO proposal(proposal_pool_id, part_id, user_id, title, description, reason, part_value_from, part_value_to)
SELECT 1, p.id, 2, 'Rear pre-load +2cm', 'First check if there was any other configuration misplaced, then proceed', 'Lap 5 - Turn 4 had really ungly correspondence', '9', '11' FROM part p WHERE p.name='Rear Pre-load';
INSERT INTO proposal(proposal_pool_id, part_id, user_id, title, description, reason, part_value_from, part_value_to)
SELECT 1, p.id, 1, 'Change to Blue power mapping', 'As we hit the goal of the Practice 2 we should move to a more aggresive map', 'We should stick to our strategy of decreasing lap times', 'Orange', 'Blue' FROM part p WHERE p.name='Power Mapping';
INSERT INTO proposal(proposal_pool_id, part_id, user_id, title, description, reason, part_value_from, part_value_to)
SELECT 1, p.id, 3, 'Decrease length by 2cm', 'This track has a lot of fast turns', 'It would help at increasing control at the sections that we have to decrease the lap times', '67cm', '65cm' FROM part p WHERE p.name='Rear swingarm length';

INSERT INTO proposal_state (proposal_id, changed_by_user_id, state)
VALUES (1, 2, 'NEW'), (2, 1, 'NEW'), (3, 3, 'NEW');

