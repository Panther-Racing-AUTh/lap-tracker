----------------------------------------
-- initialization of the Database Data--
----------------------------------------

INSERT INTO roles(role, description)
VALUES 
('admin', 'This is the admin role. An admin has access to all users and their roles and all features of the application.'),
('engineer','This is the engineer role. It is the standard role and unlocks all features of the application.'),
('data_analyst','This is the data analyst role. This role has only access to data from previous sessions.'),
('default','This is the default role. This role has no rights in the application.');

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



