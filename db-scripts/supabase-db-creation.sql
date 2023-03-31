----------------------------------------
--	creation of the Database Tables	  --
----------------------------------------

-- ALTER TABLE part
-- 	DROP CONSTRAINT fk_part_values;
-- ALTER TABLE part_values
-- 	DROP CONSTRAINT fk_part;

-- DROP ALL TABLES BEFORE CREATION
DROP TABLE IF EXISTS canbus_data;
DROP TABLE IF EXISTS canbus_timeline;
DROP TABLE IF EXISTS lap;
DROP TABLE IF EXISTS season;

DROP TABLE IF EXISTS part_values;

DROP TABLE IF EXISTS proposal_state;
DROP TABLE IF EXISTS proposal;
DROP TABLE IF EXISTS proposal_pool;

DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS subsystem;
DROP TABLE IF EXISTS system;
DROP TABLE IF EXISTS vehicle;

DROP TABLE IF EXISTS session;
DROP TABLE IF EXISTS event_date;
DROP TABLE IF EXISTS racetrack;

DROP TABLE IF EXISTS channel_users;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS channel;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;

CREATE TABLE season (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR(150)	NOT NULL,
	description		TEXT			NOT NULL
);
comment on table season is 'The season of the team ex. `2022-2023` or maybe MotoStudent VII';
comment on column season.name is 'The name of the season ex. MotoStudent VII';
comment on column season.description is 'Description about the season ex. `Motostudent VII is taking place at Aragon Circuit at 11-14 of Octomber 2023`';

CREATE TABLE event_date (
	id				SERIAL		PRIMARY KEY,
	date			timestamp	NOT NULL,
	description		TEXT		NOT NULL
);
comment on table event_date is 'The ';
comment on column event_date.date is 'The date ex. 14/02/2023';
comment on column event_date.description is 'Description about this date ex. First day for practice and fine tuning';

CREATE TABLE racetrack (	
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR(100)	NOT NULL,
	country			VARCHAR(10)		NOT NULL,
	country_code	VARCHAR(10)		NOT NULL
);
comment on table racetrack is 'The racetrack that the event is taking place';
comment on column racetrack.name is 'The name of the racetrack ex. Aragon';
comment on column racetrack.country is 'The country of the racetrack ex. Spain';
comment on column racetrack.country_code is 'The code to refence the country of the racetrack ex. es';

CREATE TABLE session (
	id				SERIAL 		PRIMARY KEY,
	racetrack_id	INT			NOT NULL,
	session_order	VARCHAR(10)	NOT NULL,
	type			VARCHAR(10)	NOT NULL,
	event_date_id  	INT			NOT NULL,
		CONSTRAINT fk_racetrack
		FOREIGN KEY(racetrack_id) 
		REFERENCES racetrack(id)
		ON DELETE CASCADE,
		CONSTRAINT fk_event_date
		FOREIGN KEY(event_date_id) 
		REFERENCES event_date(id)
		ON DELETE CASCADE
);
comment on table session is 'The session of the day. In one maybe there are three or more sessions';
comment on column session.racetrack_id is 'The id that references the recetrack info ex. 12 (id)';
comment on column session.session_order is 'The order that this session happend ex. session 2';
comment on column session.type is 'The type of the session ex. practice';

CREATE TABLE lap (
	id				SERIAL		PRIMARY KEY,
	session_id		INT			NOT NULL,
	lap_order		VARCHAR(10)	NOT NULL,
	created_at		TIMESTAMPTZ	NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_session
		FOREIGN KEY(session_id) 
		REFERENCES session(id)
		ON DELETE CASCADE
);
comment on table lap is 'The lap is the lower level of the hierarchy, holds basic info about the lap such as where (racetrack_id) and when (session_id)';
comment on column lap.session_id is 'The id that references the session info ex. 502 (id)';
comment on column lap.lap_order is 'The order of the lap ex. lap 8. If is 0 that means that the laps could not be seperated.';
comment on column lap.created_at is 'The time of the creation of the row';

CREATE TABLE canbus_timeline (
	id				SERIAL		PRIMARY KEY,
	lap_id			INT			NOT NULL,
	timestamp		TIMESTAMPTZ	NOT NULL,
	CONSTRAINT fk_lap
		FOREIGN KEY(lap_id)
		REFERENCES lap(id)
		ON DELETE CASCADE
);
comment on table canbus_timeline is 'The canbus timeline that has been recored at the lap';
comment on column canbus_timeline.lap_id is 'The id that references the exact lap.';
comment on column canbus_timeline.timestamp is 'The time of the value ex. 15:02:46.310 | one to many with the canbus_data';
CREATE INDEX index_timestamp
ON canbus_timeline (timestamp);

CREATE TABLE canbus_data (
	id					SERIAL			PRIMARY KEY,
	canbus_timeline_id	INT				NOT NULL,
	canbus_id			VARCHAR(16)		NOT NULL,
	value				DECIMAL			NOT NULL,
	canbus_id_name		VARCHAR(120)	NOT NULL,
	unit				VARCHAR(64)		NOT NULL,
	CONSTRAINT fk_canbus_timeline
		FOREIGN KEY(canbus_timeline_id) 
		REFERENCES canbus_timeline(id)
		ON DELETE CASCADE
);
comment on table canbus_data is 'Based on the time referenced at `canbus_timeline_id` it stores a pair of canbus_id and a value, ex. tire temperature has `15E` as canbus_id and a value of 45°C';
comment on column canbus_data.canbus_timeline_id is 'The reference to the time of the value ex. 150 (is just an id)';
comment on column canbus_data.canbus_id is 'The id that the logger uses ex. 15E';
comment on column canbus_data.value is 'The value that is written at this timestamp for this canbus_id ex. 45.2';
comment on column canbus_data.canbus_id_name is 'The name if the canbus id ex. for 15E we have a name of `Tire temperature`';
comment on column canbus_data.unit is 'The measurement unit that will be used to present the value ex. C for Celcius';
CREATE INDEX index_canbus_id
ON canbus_data (canbus_id);
CREATE INDEX index_canbus_id
ON canbus_data (canbus_id_name);

CREATE TABLE users (
	id			SERIAL	PRIMARY KEY,
	uuid		UUID,
	email		TEXT,
	password	TEXT,
	provider	TEXT,
	created_at	TIMESTAMPTZ	DEFAULT NOW(),
	full_name	TEXT		DEFAULT 'Firstname_Lastname',
	about		TEXT		DEFAULT 'about_section',
	role		TEXT		DEFAULT 'no_role',
	department	TEXT		DEFAULT 'department',
	active		BOOLEAN		DEFAULT TRUE
);
comment on table users is 'Stores all users registered at the application';
comment on column users.uuid is 'Supabase assigned unique id. The relation to auth.users.uuid has to be done from Supabase platform.';
comment on column users.email is 'User email';
comment on column users.password is 'User password';
comment on column users.provider is 'Where the user is registered from';
comment on column users.created_at is 'Timestamp of the creation of the user';
comment on column users.full_name is 'Full name of the user';
comment on column users.about is 'Some words as a description for the profile of the user';
comment on column users.role is 'The active role of the user s department';
comment on column users.department is 'The department of the user';
comment on column users.active is 'If is active its true, if he is not its false';

CREATE TABLE roles (
	id			SERIAL	PRIMARY KEY,
	role		TEXT,
	description	TEXT
);
comment on table roles is 'Stores all roles available at the application';
comment on column roles.role is 'The name of the role, ex. Chief Engineer';
comment on column roles.description is 'A description of the role and that is capable of, ex. Chief Engineer can see ...';

CREATE TABLE user_roles (
	id				SERIAL		PRIMARY KEY,
	user_id			INT,
	role_id			INT,
	created_at		TIMESTAMP	DEFAULT NOW(),
	last_modified	TIMESTAMP	DEFAULT NOW(),
	CONSTRAINT fk_users
		FOREIGN KEY(user_id)
		REFERENCES users(id)
		ON DELETE NO ACTION,
	CONSTRAINT fk_roles
		FOREIGN KEY(role_id)
		REFERENCES roles(id)
		ON DELETE NO ACTION
);
comment on table user_roles is 'This table is to assign roles, it connects the existing users with the existing roles';
comment on column user_roles.user_id is 'The reference to the user by id';
comment on column user_roles.role_id is 'The reference to the role by id';

CREATE TABLE channel (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	name		VARCHAR(250)
);
comment on table channel is 'This table stores all channels';
comment on column channel.created_at is 'Timestamp of the creation of the channel';
comment on column channel.name is 'The name of the channel';

CREATE TABLE message (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	content		TEXT,
	user_id		INT,
	channel_id	INT,
	type		TEXT,
	CONSTRAINT fk_message_users
		FOREIGN KEY(user_id)
		REFERENCES users(id)
		ON DELETE NO ACTION,
	CONSTRAINT fk_channel
		FOREIGN KEY(channel_id)
		REFERENCES channel(id)
		ON DELETE NO ACTION
);
comment on table message is 'This table stores all messages';
comment on column message.created_at is 'Timestamp of the creation of the message';
comment on column message.content is 'The content of the message';
comment on column message.user_id is 'The reference to the user by id';
comment on column message.channel_id is 'The reference to the channel by id';
comment on column message.type is 'The type of the message';

CREATE TABLE channel_users (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	user_id		INT,
	channel_id	INT,
	CONSTRAINT fk_channel_users_users
		FOREIGN KEY(user_id)
		REFERENCES users(id)
		ON DELETE NO ACTION,
	CONSTRAINT fk_channel_users_channel
		FOREIGN KEY(channel_id)
		REFERENCES channel(id)
		ON DELETE NO ACTION
);
comment on table channel_users is 'This table stores all users within the channels and vise-versa, all channels of the user';
comment on column channel_users.created_at is 'Timestamp of the insertion of the user at the channel';
comment on column channel_users.user_id is 'The reference to the user by id';
comment on column channel_users.channel_id is 'The reference to the channel by id';

CREATE TABLE vehicle (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	name		VARCHAR(250),
	year		VARCHAR(16),
	description	VARCHAR(250)
);
comment on table vehicle is 'This table stores all users within the channels and vise-versa, all channels of the user';
comment on column vehicle.created_at is 'Timestamp of the creation of the vehicle';
comment on column vehicle.name is 'The name of the vehicle, ex. Black Panther';
comment on column vehicle.year is 'The year of the vehicle, ex. 2019-2021';
comment on column vehicle.description is 'The description of the vehicle, ex. Motorcycle prototype | KTM-RC 250cc';

CREATE TABLE system (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	name		VARCHAR(250),
	vehicle_id	INT,
	description	VARCHAR(250),
	CONSTRAINT fk_vehicle
		FOREIGN KEY(vehicle_id)
		REFERENCES vehicle(id)
		ON DELETE NO ACTION
);
comment on table system is 'The system of the vehicle';
comment on column system.created_at is 'Timestamp of the creation of the system';
comment on column system.name is 'The name of the system, ex. Suspension';
comment on column system.vehicle_id is 'The reference to the vehicle, ex. id: 1';
comment on column system.description is 'The description of the system, ex. Front and rear suspensions';

CREATE TABLE subsystem (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	name		VARCHAR(250),
	system_id	INT,
	description	VARCHAR(250),
	CONSTRAINT fk_system
		FOREIGN KEY(system_id)
		REFERENCES system(id)
		ON DELETE NO ACTION
);
comment on table subsystem is 'The subsystem of the system';
comment on column subsystem.created_at is 'Timestamp of the creation of the subsystem';
comment on column subsystem.name is 'The name of the subsystem, ex. Front Suspension';
comment on column subsystem.system_id is 'The reference to the system, ex. id: 5';
comment on column subsystem.description is 'The description of the system, ex. Front suspension | Adriani';

CREATE TABLE part (
	id					SERIAL		PRIMARY KEY,
	created_at			TIMESTAMP	DEFAULT NOW(),
	name				VARCHAR(250),
	subsystem_id		INT,
	current_value_id	INT,
	measurement_unit	VARCHAR(250),
	CONSTRAINT fk_subsystem
		FOREIGN KEY(subsystem_id)
		REFERENCES subsystem(id)
		ON DELETE NO ACTION
);
comment on table part is 'The subsystem of the system';
comment on column part.created_at is 'Timestamp of the creation of the part';
comment on column part.name is 'The name of the part, ex. compression';
comment on column part.subsystem_id is 'The reference to the subsystem, ex. id: 16';
comment on column part.current_value_id is 'The reference to the part_values, ex. id: 62';
comment on column part.measurement_unit is 'The measurement unit of the part, ex. Newtons (N)';

CREATE TABLE part_values (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	part_id		INT,
	value		INT,
	CONSTRAINT fk_part
		FOREIGN KEY(part_id)
		REFERENCES part(id)
		ON DELETE NO ACTION
);
comment on table part_values is 'The subsystem of the system';
comment on column part_values.created_at is 'Timestamp of the creation of the value';
comment on column part_values.part_id is 'The reference to the part, ex. id: 54';
comment on column part_values.value is 'The value setted, ex. 1270 (Newtons)';

CREATE TABLE proposal_pool (
	id			SERIAL		PRIMARY KEY,
	created_at	TIMESTAMP	DEFAULT NOW(),
	session_id	INT			DEFAULT NULL,
	vehicle_id	INT,
	ended		BOOLEAN		DEFAULT FALSE,
	CONSTRAINT fk_proposal_pool_session
		FOREIGN KEY(session_id) 
		REFERENCES session(id)
		ON DELETE CASCADE,
	CONSTRAINT fk_vehicle
		FOREIGN KEY(vehicle_id)
		REFERENCES vehicle(id)
		ON DELETE NO ACTION
);
comment on table proposal_pool is 'The subsystem of the system';
comment on column proposal_pool.created_at is 'Timestamp of the creation of the proposal_pool';
comment on column proposal_pool.session_id is 'The reference to the session id, ex. id: 25';
comment on column proposal_pool.vehicle_id is 'The reference to the vehicle id, ex. id: 4';
comment on column proposal_pool.ended is 'A boolean so the team will know when this  proposal pool closed';

CREATE TABLE proposal (
	id					SERIAL		PRIMARY KEY,
	created_at			TIMESTAMP	DEFAULT NOW(),
	proposal_pool_id	INT			DEFAULT NULL,
	part_id				INT			DEFAULT NULL,
	user_id				INT,
	title				VARCHAR(250),
	description			TEXT,
	reason				TEXT,
	json_data			JSON,
	part_value_from		VARCHAR(250),
	part_value_to		VARCHAR(250),
	CONSTRAINT fk_proposal_proposal_pool
		FOREIGN KEY(proposal_pool_id) 
		REFERENCES proposal_pool(id)
		ON DELETE CASCADE,
	CONSTRAINT fk_proposal_users
		FOREIGN KEY(user_id)
		REFERENCES users(id)
		ON DELETE NO ACTION,
	CONSTRAINT fk_proposal_part
		FOREIGN KEY(part_id)
		REFERENCES part(id)
		ON DELETE NO ACTION
);
comment on table proposal is 'The subsystem of the system';
comment on column proposal.created_at is 'Timestamp of the creation of the proposal';
comment on column proposal.proposal_pool_id is 'The reference to the proposal_pool, ex. id: 265';
comment on column proposal.user_id is 'The reference to the user by id';
comment on column proposal.title is 'The title of the proposal, ex. Front Fork 3 turns';
comment on column proposal.description is 'The description of the proposal (if needed), ex. FIRST remove this THEN do that';
comment on column proposal.reason is 'The reason of the proposal, ex. lap 5 turn 2 seemed unstable and wombled';
comment on column proposal.json_data is 'All the extra data passed as json, ex. {canbusData: [{canbusTimelineFromId: 25835, canbusTimelineToId: 53210, sessionId: 592},{filters: {showonly:[tire_pressure,tire_temperature,FR_SUS]}}]}';

CREATE TABLE proposal_state (
	id					SERIAL		PRIMARY KEY,
	created_at			TIMESTAMP	DEFAULT NOW(),
	proposal_id			INT			DEFAULT NULL,
	changed_by_user_id	INT,
	state				VARCHAR(20) DEFAULT 'NEW',
	CONSTRAINT fk_proposal_state_proposal
		FOREIGN KEY(proposal_id) 
		REFERENCES proposal(id)
		ON DELETE CASCADE,
	CONSTRAINT fk_proposal_state_users
		FOREIGN KEY(changed_by_user_id)
		REFERENCES users(id)
		ON DELETE NO ACTION
);
comment on table proposal_state is 'The subsystem of the system';
comment on column proposal_state.created_at is 'Timestamp of the creation of the proposal';
comment on column proposal_state.proposal_id is 'The reference to the proposal, ex. id: 354';
comment on column proposal_state.changed_by_user_id is 'The reference to the user by id';
comment on column proposal_state.state is 'The state has to be a distinct value between: NEW, APPROVED, DECLINED, DONE';





----------------------------------------------
-- create helper table until we sort it out --
----------------------------------------------
-- this table is needed because table is the only way to stream data,
-- supabase/flutter doesn't support yet having joins at stream
-- neither it supports views for streaming
-- the only way was to create triggers and replicate a view
-- through a table so it can run smoothly and easy
CREATE TABLE t_v_proposals (
	id									SERIAL PRIMARY KEY,
	PROPOSAL__id						INT,
	PROPOSAL__created_at				TIMESTAMP,
	PROPOSAL__proposal_pool_id			INT,
	PROPOSAL__part_id					INT,
	PROPOSAL__user_id					INT,
	PROPOSAL__title						VARCHAR(250),
	PROPOSAL__description				TEXT,
	PROPOSAL__reason					TEXT,
	PROPOSAL__json_data					JSON,
	PROPOSAL__part_value_from			VARCHAR(250),
	PROPOSAL__part_value_to				VARCHAR(250),
	PROPOSAL_POOL__id					INT,
	PROPOSAL_POOL__created_at			TIMESTAMP,
	PROPOSAL_POOL__session_id			INT,
	PROPOSAL_POOL__vehicle_id			INT,
	PROPOSAL_POOL__ended				BOOLEAN,
	PROPOSAL_STATE__id					INT,
	PROPOSAL_STATE__created_at			TIMESTAMP,
	PROPOSAL_STATE__proposal_id			INT,
	PROPOSAL_STATE__changed_by_user_id	INT,
	PROPOSAL_STATE__state				VARCHAR(20),
	PART__id							INT,
	PART__created_at					TIMESTAMP,
	PART__name							VARCHAR(250),
	PART__subsystem_id					INT,
	PART__current_value_id				INT,
	PART__measurement_unit				VARCHAR(250),
	PART_VALUES__id						INT,
	PART_VALUES__created_at				TIMESTAMP,
	PART_VALUES__part_id				INT,
	PART_VALUES__value					INT,
	USER__id							INT,
	USER__uuid							UUID,
	USER__full_name						TEXT,
	USER__role							TEXT,
	USER__department					TEXT
);
