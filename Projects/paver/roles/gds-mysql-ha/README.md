Role Name
=========

A wrapper role for roles gds_mha_manager and gds_mysql for playbook simplification and relaxed dependency handling.

Role Variables
--------------

The following variables are supported:
- instance

Dependencies
------------

- gds_mha_manager
- gds_mysql

Example Playbook
----------------

To use this role, you can define it as follows:

    - hosts: my-mysql-db-cluster-01
      roles:
         - role: gds-mysql-ha
           instance: testdb01
         - role: gds-mysql-ha
           instance: testdb02

License
-------

BSD

Author Information
------------------

Robert Barabas (rbarabas@groupon.com)
