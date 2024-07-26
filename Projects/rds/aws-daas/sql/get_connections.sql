SELECT COUNT(*)
  FROM (
        SELECT pid
             , usename
             , state
             , application_name
             , wait_event
             , client_addr
          FROM pg_stat_activity
         WHERE usename IS NOT NULL
           AND usename != 'rdsadmin'
           AND state IS NOT NULL
           AND pid != pg_backend_pid()
           AND backend_type = 'client backend'
        ) c;
