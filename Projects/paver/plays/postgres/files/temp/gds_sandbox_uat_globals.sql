--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE gds_sandbox_uat_app;
ALTER ROLE gds_sandbox_uat_app WITH  INHERIT NOCREATEROLE NOCREATEDB LOGIN ;
CREATE ROLE gds_sandbox_uat_dba;
ALTER ROLE gds_sandbox_uat_dba WITH  INHERIT NOCREATEROLE NOCREATEDB LOGIN ;
CREATE ROLE test_dba;
ALTER ROLE test_dba WITH  INHERIT NOCREATEROLE NOCREATEDB LOGIN   PASSWORD 'md5446f33861d94ed9d67cd35019407d2e5';
ALTER ROLE test_dba SET search_path TO test_snadbox;






--
-- PostgreSQL database cluster dump complete
--

