Role Name
=========

Wrapper role to define mysql server baseline and deal with role dependencies in an abstract way.

Role Variables
--------------

N/A

Dependencies
------------

- consul
- delorean
- gds_firewall
- os-config
- common_install
- openntpd
- gds_carp
- gds_motd


Example Playbook
----------------

Include the role in the playbook simply like below:
    - hosts: servers
      roles:
         - gds-mysql-server

License
-------

BSD

Author Information
------------------

Robert Barabas (rbarabas@groupon.com)
