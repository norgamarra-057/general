 This project is part of the FreeBSD setup for GDS at Groupon. An index of related projects can be found here: [FreeBSD index](https://confluence.groupondev.com/display/GDSI/FreeBSD+Index)

[release strategy]: release_strategy.md



# Ansible Playbook for GDS servers

Platform version 1

## Release strategy
  Under the link you'll find our detailed [release strategy]!

## how to run this playbook
1) install Ansible on your machine

2) Verify ansible is working:

```bash
ansible all -i inventory/gds-production --list-hosts
ansible all --list-hosts
ansible gds -m ping
````

3) run the following command to run a check (-C specifies check, but
don't change):

```bash
ansible-playbook -C foreman.yml
ansible-playbook --limit central-db15.snc1 foreman.yml
ansible-playbook -e ansible_ssh_user=root --limit gds-db001m1.snc1 foreman.yml
env ANSIBLE_ROOT=${PWD}/inventory/staging ansible-playbook -C site.yml
# Useful in debugging:
env ANSIBLE_KEEP_REMOTE_FILES=1 ansible-playbook -vvv site.yml

#### Useful adhoc commands:
# Copy a file to remote hosts
% ansible -i inventory/delorean-production -m copy -a "src=roles/common_install/files/local.txt dest=/tmp/remote.txt" all
# Run a command that accepts sh(1) redirection
% ansible -i inventory/delorean-production -m shell -a 'uptime > /tmp/uptime.out' all
# Run a command that doesn't use sh(1) to start the process
% ansible -i inventory/delorean-production -m command -a 'cat /tmp/uptime.out' all

##### Useful individual commands
# See what hosts will be acted upon in a given run
% ansible-playbook --list-hosts -i inventory/delorean-production site.yml

# See what tasks will be run against host(s)
% ansible-playbook --list-tasks -i inventory/delorean-production site.yml

# Run only the NTP items
% ansible-playbook -i inventory/delorean-production -t ntp site.yml
````

### details
The playbook structure is set towards using Ansible's "Roles" feature:

http://docs.ansible.com/playbooks_roles.html#roles

#### running the playbook directly on the remote host
1) copy the whole Playbook with all its subfolders and files to the remote host

2) replace the hosts statement on top of the "site.yml" with "hosts: 127.0.0.1"

3) run the following command:
```bash
ansible-playbook site.yml --connection=local
```

more information on local playbooks here:

http://docs.ansible.com/playbooks_delegation.html#local-playbooks

#### Ansible-Pull
For those who prefer to pull config to the host instead of pushing, there's Ansible-Pull:

http://docs.ansible.com/playbooks_intro.html#ansible-pull

An example playbook to push cron config to hosts for this feature, written by Michael DeHaan, is here:

https://github.com/ansible/ansible-examples/blob/master/language_features/ansible_pull.yml

#### adding packages
In order to add packages to the freebsd_commons Role, edit the following file:
```bash
roles/freebsd_commons/tasks/main.yml
````

#### managing users
For user management, take a look at gds/user-provisioning. The foreman component of this repository is going to be superseded by the user-provisioning repository in the near future. For more informatiabout the old method please consult the GDS confluence site or take a look at this file:
```bash
roles/foreman/tasks/main.yml
````

### where this is going
Ideally the organization of data, action items and possibly templates will be
partitioned into more folders and files according to Ansible's Roles standard.

For example, there will be distinct operating systems or rdbms to support, which
means that modules like "pkgng" or operations such as user management will get split
out into conditionals, so depending on what system we're on the appropriate modules will
be employed for the task at hand.
N
