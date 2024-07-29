-- ------------------------------------------------------
-- Host: RDS
-- ------------------------------------------------------
-- Database: gds_validate
-- ------------------------------------------------------
-- gds_validate - Version 1.1.0
-- ------------------------------------------------------

create table if not exists summary (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `run` varchar(255) NOT NULL,
    `db_name` varchar(64) NOT NULL,
    `on_prem_table_count` int(11) DEFAULT '0',
    `cloud_table_count` int(11) DEFAULT '0',
    `on_prem_view_count` int(11) DEFAULT '0',
    `cloud_view_count` int(11) DEFAULT '0',
    `on_prem_routine_count` int(11) DEFAULT '0',
    `cloud_routine_count` int(11) DEFAULT '0',
    `on_prem_trigger_count` int(11) DEFAULT '0',
    `cloud_trigger_count` int(11) DEFAULT '0',
    `on_prem_event_count` int(11) DEFAULT '0',
    `cloud_event_count` int(11) DEFAULT '0',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `run` (`run`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table if not exists tables (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `run` varchar(255) NOT NULL,
    `db_name` varchar(64) NOT NULL,
    `on_prem_name` varchar(64) NOT NULL,
    `on_prem_rows` int(11) NOT NULL DEFAULT 0,
    `cloud_name` varchar(64) NOT NULL,
    `cloud_rows` int(11) NOT NULL DEFAULT 0,
    `prct_diff` int(11) unsigned DEFAULT 0,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `run` (`run`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table if not exists views (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `run` varchar(255) NOT NULL,
    `db_name` varchar(64) DEFAULT NULL,
    `on_prem_name` varchar(64) DEFAULT NULL,
    `cloud_name` varchar(64) DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `run` (`run`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table if not exists routines (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `run` varchar(255) NOT NULL,
    `db_name` varchar(64) DEFAULT NULL,
    `on_prem_name` varchar(64) DEFAULT NULL,
    `on_prem_type` varchar(64) DEFAULT NULL,
    `cloud_name` varchar(64) DEFAULT NULL,
    `cloud_type` varchar(64) DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `run` (`run`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table if not exists triggers (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `run` varchar(255) NOT NULL,
    `db_name` varchar(64) DEFAULT NULL,
    `on_prem_name` varchar(64) DEFAULT NULL,
    `on_prem_type` varchar(64) DEFAULT NULL,
    `on_prem_table_name` varchar(64) DEFAULT NULL,
    `cloud_name` varchar(64) DEFAULT NULL,
    `cloud_type` varchar(64) DEFAULT NULL,
    `cloud_table_name` varchar(64) DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `run` (`run`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table if not exists events (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `run` varchar(255) NOT NULL,
    `db_name` varchar(64) DEFAULT NULL,
    `on_prem_name` varchar(64) DEFAULT NULL,
    `cloud_name` varchar(64) DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `run` (`run`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table if not exists audit_log (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `run` varchar(255) NOT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `table_name` varchar(64) DEFAULT NULL,
    `message` varchar(255) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `run` (`run`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER ;;

DROP TRIGGER IF EXISTS summary_insert;;

CREATE TRIGGER summary_insert AFTER INSERT
ON summary FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("INSERT INTO summary: id: ", NEW.id);
	INSERT INTO audit_log (run, table_name, message) values (NEW.run, "summary", l_message);
END;;

DROP TRIGGER IF EXISTS summary_update;;

CREATE TRIGGER summary_update AFTER UPDATE
ON summary FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("UPDATE summary: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "summary", l_message);
END;;

DROP TRIGGER IF EXISTS summary_delete;;

CREATE TRIGGER summary_delete BEFORE DELETE
ON summary FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("DELETE FROM summary: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "summary", l_message);
END;;

DROP TRIGGER IF EXISTS tables_before_insert;;

CREATE TRIGGER tables_before_insert BEFORE INSERT
ON tables FOR EACH ROW
BEGIN
        DECLARE l_percent float;

        IF NEW.on_prem_rows > 0 AND NEW.cloud_rows > 0 THEN
           set l_percent = ((NEW.cloud_rows / NEW.on_prem_rows ) * 100 ) - 100;
        ELSE
           set l_percent = NULL;
        END IF;

        SET NEW.prct_diff = l_percent;
END;;

DROP TRIGGER IF EXISTS tables_after_insert;;

CREATE TRIGGER tables_after_insert AFTER INSERT
ON tables FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("INSERT INTO tables: id: ", NEW.id);
	INSERT INTO audit_log (run, table_name, message) values (NEW.run, "tables", l_message);
END;;

DROP TRIGGER IF EXISTS tables_update;;

CREATE TRIGGER tables_update AFTER UPDATE
ON tables FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("UPDATE tables: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "tables", l_message);
END;;

DROP TRIGGER IF EXISTS tables_delete;;

CREATE TRIGGER tables_delete BEFORE DELETE
ON tables FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("DELETE FROM tables: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "tables", l_message);
END;;

DROP TRIGGER IF EXISTS routines_insert;;

CREATE TRIGGER routines_insert AFTER INSERT
ON routines FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("INSERT INTO routines: id: ", NEW.id);
	INSERT INTO audit_log (run, table_name, message) values (NEW.run, "routines", l_message);
END;;

DROP TRIGGER IF EXISTS routines_update;;

CREATE TRIGGER routines_update AFTER UPDATE
ON routines FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("UPDATE routines: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "routines", l_message);
END;;

DROP TRIGGER IF EXISTS routines_delete;;

CREATE TRIGGER routines_delete BEFORE DELETE
ON routines FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("DELETE FROM routines: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "routines", l_message);
END;;

DROP TRIGGER IF EXISTS triggers_insert;;

CREATE TRIGGER triggers_insert AFTER INSERT
ON triggers FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("INSERT INTO triggers: id: ", NEW.id);
	INSERT INTO audit_log (run, table_name, message) values (NEW.run, "triggers", l_message);
END;;

DROP TRIGGER IF EXISTS triggers_update;;

CREATE TRIGGER triggers_update AFTER UPDATE
ON triggers FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("UPDATE triggers: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "triggers", l_message);
END;;

DROP TRIGGER IF EXISTS triggers_delete;;

CREATE TRIGGER triggers_delete BEFORE DELETE
ON triggers FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("DELETE triggers: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "triggers", l_message);
END;;

DROP TRIGGER IF EXISTS events_insert;;

CREATE TRIGGER events_insert AFTER INSERT
ON events FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("INSERT INTO events: id: ", NEW.id);
	INSERT INTO audit_log (run, table_name, message) values (NEW.run, "events", l_message);
END;;

DROP TRIGGER IF EXISTS events_update;;

CREATE TRIGGER events_update AFTER UPDATE
ON events FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("UPDATE events: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "events", l_message);
END;;

DROP TRIGGER IF EXISTS events_delete;;

CREATE TRIGGER events_delete BEFORE DELETE
ON events FOR EACH ROW
BEGIN
	DECLARE l_message varchar(255);
	set l_message = CONCAT("DELETE events: id: ", OLD.id);
	INSERT INTO audit_log (run, table_name, message) values (OLD.run, "events", l_message);
END;;

DELIMITER ;
