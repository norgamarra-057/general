--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: ext; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ext;


ALTER SCHEMA ext OWNER TO postgres;

--
-- Name: gds_sandbox; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gds_sandbox;


ALTER SCHEMA gds_sandbox OWNER TO postgres;

--
-- Name: test_snadbox; Type: SCHEMA; Schema: -; Owner: test_dba
--

CREATE SCHEMA test_snadbox;


ALTER SCHEMA test_snadbox OWNER TO test_dba;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA ext;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: pglogical_origin; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pglogical_origin WITH SCHEMA pglogical_origin;


--
-- Name: EXTENSION pglogical_origin; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pglogical_origin IS 'PostgreSQL Logical Replication Origin Tracking Emulation for 9.4';


--
-- Name: pglogical; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pglogical WITH SCHEMA pglogical;


--
-- Name: EXTENSION pglogical; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pglogical IS 'PostgreSQL Logical Replication';


--
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA ext;


--
-- Name: EXTENSION postgres_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';


SET search_path = gds_sandbox, pg_catalog;

--
-- Name: f_insert_tag(integer, text); Type: FUNCTION; Schema: gds_sandbox; Owner: postgres
--

CREATE FUNCTION f_insert_tag(tag_p_id integer, _tag text, OUT tag_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO t(tag_id, tag) VALUES (tag_p_id, _tag) RETURNING t.tag_id INTO tag_id;

EXCEPTION WHEN UNIQUE_VIOLATION THEN  -- catch exception, NULL is returned
END
$$;


ALTER FUNCTION gds_sandbox.f_insert_tag(tag_p_id integer, _tag text, OUT tag_id integer) OWNER TO postgres;

--
-- Name: test_delete(integer); Type: FUNCTION; Schema: gds_sandbox; Owner: postgres
--

CREATE FUNCTION test_delete(nap integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
 declare
         rec     RECORD;
         sql     varchar;
         delsql  varchar;
         v_uuid  uuid;
         counter integer;
         timing timestamp;
 begin
         sql := 'select id from test limit 10';
         counter = 0;
         --raise notice 'sql %' ,sql;
         for rec in execute sql loop
               -- SELECT message_uuid into v_uuid from message_statuses where message_uuid=rec.message_uuid;
                 delete from test where id = rec.id;
                 --delsql='delete from gis.inventory_unit_events where uuid = '||quote_literal(rec.uuid);
                 --execute delsql;
                --RAISE NOTICE 'delsql %',delsql;
                 RAISE NOTICE ' UUID ID = %',rec.id;
                counter = counter + 1;
                if mod(counter,2)=0 then
                 --     RAISE NOTICE 'Sleeping';
                      PERFORM pg_sleep(nap);
                      RAISE NOTICE 'Counter=%',counter;
                end if;
         end loop;
         RAISE NOTICE 'Complete';
         RETURN 'OK';
        exception
        when others then
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        return -1;
 end;
 $$;


ALTER FUNCTION gds_sandbox.test_delete(nap integer) OWNER TO postgres;

--
-- Name: pgbouncer_ses; Type: SERVER; Schema: -; Owner: postgres
--

CREATE SERVER pgbouncer_ses FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'pgbouncer',
    host '127.0.0.1',
    port '20001'
);


ALTER SERVER pgbouncer_ses OWNER TO postgres;

--
-- Name: USER MAPPING postgres SERVER pgbouncer_ses; Type: USER MAPPING; Schema: -; Owner: postgres
--

CREATE USER MAPPING FOR postgres SERVER pgbouncer_ses OPTIONS (
    password 'gds123123',
    "user" 'gdsmon'
);


--
-- Name: pgbouncer_trx; Type: SERVER; Schema: -; Owner: postgres
--

CREATE SERVER pgbouncer_trx FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'pgbouncer',
    host '127.0.0.1',
    port '20000'
);


ALTER SERVER pgbouncer_trx OWNER TO postgres;

--
-- Name: USER MAPPING postgres SERVER pgbouncer_trx; Type: USER MAPPING; Schema: -; Owner: postgres
--

CREATE USER MAPPING FOR postgres SERVER pgbouncer_trx OPTIONS (
    password 'gds123123',
    "user" 'gdsmon'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: t; Type: TABLE; Schema: gds_sandbox; Owner: postgres; Tablespace: 
--

CREATE TABLE t (
    tag_id integer NOT NULL,
    tag text
);


ALTER TABLE t OWNER TO postgres;

--
-- Name: test; Type: TABLE; Schema: gds_sandbox; Owner: postgres; Tablespace: 
--

CREATE TABLE test (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE test OWNER TO postgres;

SET search_path = test_snadbox, pg_catalog;

--
-- Name: pgbench_accounts; Type: TABLE; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

CREATE TABLE pgbench_accounts (
    aid integer NOT NULL,
    bid integer,
    abalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE pgbench_accounts OWNER TO test_dba;

--
-- Name: pgbench_branches; Type: TABLE; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

CREATE TABLE pgbench_branches (
    bid integer NOT NULL,
    bbalance integer,
    filler character(88),
    pid integer
)
WITH (fillfactor='100');


ALTER TABLE pgbench_branches OWNER TO test_dba;

--
-- Name: pgbench_history; Type: TABLE; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

CREATE TABLE pgbench_history (
    tid integer NOT NULL,
    bid integer,
    aid integer NOT NULL,
    delta integer,
    mtime timestamp without time zone,
    filler character(22),
    id integer NOT NULL
);


ALTER TABLE pgbench_history OWNER TO test_dba;

--
-- Name: pgbench_history_id_seq; Type: SEQUENCE; Schema: test_snadbox; Owner: test_dba
--

CREATE SEQUENCE pgbench_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pgbench_history_id_seq OWNER TO test_dba;

--
-- Name: pgbench_history_id_seq; Type: SEQUENCE OWNED BY; Schema: test_snadbox; Owner: test_dba
--

ALTER SEQUENCE pgbench_history_id_seq OWNED BY pgbench_history.id;


--
-- Name: pgbench_tellers; Type: TABLE; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

CREATE TABLE pgbench_tellers (
    tid integer NOT NULL,
    bid integer,
    tbalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE pgbench_tellers OWNER TO test_dba;

--
-- Name: t1; Type: TABLE; Schema: test_snadbox; Owner: postgres; Tablespace: 
--

CREATE TABLE t1 (
    id integer NOT NULL
);


ALTER TABLE t1 OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: test_snadbox; Owner: test_dba
--

ALTER TABLE ONLY pgbench_history ALTER COLUMN id SET DEFAULT nextval('pgbench_history_id_seq'::regclass);


SET search_path = gds_sandbox, pg_catalog;

--
-- Name: t_pkey; Type: CONSTRAINT; Schema: gds_sandbox; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t
    ADD CONSTRAINT t_pkey PRIMARY KEY (tag_id);


--
-- Name: t_tag_key; Type: CONSTRAINT; Schema: gds_sandbox; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t
    ADD CONSTRAINT t_tag_key UNIQUE (tag);


--
-- Name: test_pkey; Type: CONSTRAINT; Schema: gds_sandbox; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id);


SET search_path = test_snadbox, pg_catalog;

--
-- Name: pgbench_accounts_pkey; Type: CONSTRAINT; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

ALTER TABLE ONLY pgbench_accounts
    ADD CONSTRAINT pgbench_accounts_pkey PRIMARY KEY (aid);


--
-- Name: pgbench_branches_pkey; Type: CONSTRAINT; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

ALTER TABLE ONLY pgbench_branches
    ADD CONSTRAINT pgbench_branches_pkey PRIMARY KEY (bid);


--
-- Name: pgbench_history_pkey; Type: CONSTRAINT; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

ALTER TABLE ONLY pgbench_history
    ADD CONSTRAINT pgbench_history_pkey PRIMARY KEY (id);


--
-- Name: pgbench_tellers_pkey; Type: CONSTRAINT; Schema: test_snadbox; Owner: test_dba; Tablespace: 
--

ALTER TABLE ONLY pgbench_tellers
    ADD CONSTRAINT pgbench_tellers_pkey PRIMARY KEY (tid);


--
-- Name: t1_pkey; Type: CONSTRAINT; Schema: test_snadbox; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY t1
    ADD CONSTRAINT t1_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: test_snadbox; Type: ACL; Schema: -; Owner: test_dba
--

REVOKE ALL ON SCHEMA test_snadbox FROM PUBLIC;
REVOKE ALL ON SCHEMA test_snadbox FROM test_dba;
GRANT ALL ON SCHEMA test_snadbox TO test_dba;


--
-- PostgreSQL database dump complete
--

