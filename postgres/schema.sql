CREATE TABLE IF NOT EXISTS responses (tx_id uuid PRIMARY KEY, ts timestamp WITH time zone DEFAULT NOW(), invalid boolean DEFAULT NULL, data jsonb);
CREATE TABLE IF NOT EXISTS feedback_responses (id SERIAL PRIMARY KEY, ts timestamp WITH time zone DEFAULT NOW(), invalid boolean DEFAULT NULL, data jsonb, survey char(25), period char(25));
CREATE SEQUENCE sequence MINVALUE 1000 MAXVALUE 9999 CYCLE;
CREATE SEQUENCE batch_sequence MINVALUE 30000 MAXVALUE 39999 CYCLE;
CREATE SEQUENCE image_sequence MINVALUE 1 MAXVALUE 999999999 CYCLE;
CREATE SEQUENCE json_sequence MINVALUE 1 MAXVALUE 999999999 CYCLE;
