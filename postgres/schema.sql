CREATE TABLE IF NOT EXISTS responses (tx_id uuid PRIMARY KEY, ts timestamp WITH time zone DEFAULT NOW(), invalid boolean DEFAULT NULL, data jsonb);
CREATE TABLE IF NOT EXISTS feedback_responses (id SERIAL PRIMARY KEY, ts timestamp WITH time zone DEFAULT NOW(), invalid boolean DEFAULT NULL, data jsonb, survey char(25), period char(25));
CREATE TABLE IF NOT EXISTS role (id integer NOT NULL,name character varying(80),description character varying(255));
CREATE TABLE IF NOT EXISTS flaskuser (id integer NOT NULL,email character varying(255),password character varying(255),active boolean,confirmed_at timestamp without time zone);
CREATE TABLE roles_users (id integer NOT NULL,user_id integer,role_id integer);

CREATE SEQUENCE role_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE flaskuser_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE roles_users_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE sequence MINVALUE 1000 MAXVALUE 9999 CYCLE;
CREATE SEQUENCE batch_sequence MINVALUE 30000 MAXVALUE 39999 CYCLE;
CREATE SEQUENCE image_sequence MINVALUE 1 MAXVALUE 999999999 CYCLE;
CREATE SEQUENCE json_sequence MINVALUE 1 MAXVALUE 999999999 CYCLE;

ALTER SEQUENCE role_id_seq OWNED BY role.id;
ALTER TABLE ONLY role ALTER COLUMN id SET DEFAULT nextval('role_id_seq'::regclass);
ALTER TABLE ONLY role ADD CONSTRAINT role_name_key UNIQUE (name);
ALTER TABLE ONLY role ADD CONSTRAINT role_pkey PRIMARY KEY (id);

ALTER SEQUENCE flaskuser_id_seq OWNED BY flaskuser.id;
ALTER TABLE ONLY flaskuser ALTER COLUMN id SET DEFAULT nextval('flaskuser_id_seq'::regclass);
ALTER TABLE ONLY flaskuser ADD CONSTRAINT flaskuser_email_key UNIQUE (email);
ALTER TABLE ONLY flaskuser ADD CONSTRAINT flaskuser_pkey PRIMARY KEY (id);

ALTER SEQUENCE roles_users_id_seq OWNED BY roles_users.id;
ALTER TABLE ONLY roles_users ALTER COLUMN id SET DEFAULT nextval('roles_users_id_seq'::regclass);
ALTER TABLE ONLY roles_users ADD CONSTRAINT roles_users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY roles_users ADD CONSTRAINT roles_users_role_id_fkey FOREIGN KEY (role_id) REFERENCES role(id);
ALTER TABLE ONLY roles_users ADD CONSTRAINT roles_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES flaskuser(id);
