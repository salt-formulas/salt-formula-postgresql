
==================
PostgreSQL Formula
==================

PostgreSQL, often simply Postgres, is an object-relational database management
system available for many platforms including Linux, FreeBSD, Solaris,
Microsoft Windows and Mac OS X. It is released under the PostgreSQL License,
which is an MIT-style license, and is thus free and open source software.
PostgreSQL is developed by the PostgreSQL Global Development Group, consisting
of a handful of volunteers employed and supervised by companies such as Red
Hat and EnterpriseDB.


Sample pillars
==============


Single deployment
-----------------

Single database server with empty database

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.1
        bind:
          address: 127.0.0.1
          port: 5432
          protocol: tcp
        clients:
        - 127.0.0.1
        database:
          databasename:
            encoding: 'UTF8'
            locale: 'cs_CZ'
            users:
              - name: 'username'
                password: 'password'
                host: 'localhost'
                rights: 'all privileges'

Single database server with initial data

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.1
        bind:
        - address: 127.0.0.1
          port: 5432
          protocol: tcp
        clients:
        - 127.0.0.1
        database:
          databasename:
            encoding: 'UTF8'
            locale: 'cs_CZ'
            initial_data:
              engine: backupninja
              source: backup.host
              host: original-host-name
              database: original-database-name
            users:
            - name: 'username'
              password: 'password'
              host: 'localhost'
              rights: 'all privileges'

User with createdb privileges

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.1
        bind:
          address: 127.0.0.1
          port: 5432
          protocol: tcp
        clients:
        - 127.0.0.1
        database:
          databasename:
            encoding: 'UTF8'
            locale: 'cs_CZ'
            users:
              - name: 'username'
                password: 'password'
                host: 'localhost'
                createdb: true
                rights: 'all privileges'

Database extensions

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.1
        bind:
          address: 127.0.0.1
          port: 5432
          protocol: tcp
        clients:
        - 127.0.0.1
        database:
          databasename:
            encoding: 'UTF8'
            locale: 'cs_CZ'
            users:
              - name: 'username'
                password: 'password'
                host: 'localhost'
                createdb: true
                rights: 'all privileges'
            extension:
              postgis_topology:
                enabled: true
              fuzzystrmatch:
                enabled: true
              postgis_tiger_geocoder:
                enabled: true
              postgis:
                enabled: true
                pkgs:
                - postgresql-9.1-postgis-2.1


Master-slave cluster
--------------------

Master node

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.6
        bind:
          address: 0.0.0.0
        database:
          mydb: ...
      cluster:
        enabled: true
        role: master
        mode: hot_standby
        members:
        - host: "172.16.10.101"
        - host: "172.16.10.102"
        - host: "172.16.10.103"
        replication_user:
          name: repuser
          password: password
    keepalived:
      cluster:
        enabled: True
        instance:
          VIP:
            notify_action:
              master:
                - 'if [ -f /root/postgresql/flags/failover ]; then touch /var/lib/postgresql/${postgresql:server:version}/main/trigger; fi'
              backup:
                - 'if [ -f /root/postgresql/flags/failover ]; then service postgresql stop; fi'
              fault:
                - 'if [ -f /root/postgresql/flags/failover ]; then service postgresql stop; fi'

Slave nodes

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.6
        bind:
          address: 0.0.0.0
      cluster:
        enabled: true
        role: slave
        mode: hot_standby
        master:
          host: "172.16.10.100"
          port: 5432
          user: repuser
          password: password
    keepalived:
      cluster:
        enabled: True
        instance:
          VIP:
            notify_action:
              master:
                - 'if [ -f /root/postgresql/flags/failover ]; then touch /var/lib/postgresql/${postgresql:server:version}/main/trigger; fi'
              backup:
                - 'if [ -f /root/postgresql/flags/failover ]; then service postgresql stop; fi'
              fault:
                - 'if [ -f /root/postgresql/flags/failover ]; then service postgresql stop; fi'

Multi-master cluster
--------------------

Multi-master cluster with 2ndQuadrant bi-directional replication plugin

Master node

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.4
        bind:
          address: 0.0.0.0
        database:
          mydb:
            extension:
              bdr:
                enabled: true
              btree_gist:
                enabled: true
      cluster:
        enabled: true
        mode: bdr
        role: master
        members:
        - host: "172.16.10.101"
        - host: "172.16.10.102"
        - host: "172.16.10.101"
        local: "172.16.10.101"
        replication_user:
          name: repuser
          password: password

Slave node

.. code-block:: yaml

    postgresql:
      server:
        enabled: true
        version: 9.4
        bind:
          address: 0.0.0.0
        database:
          mydb:
            extension:
              bdr:
                enabled: true
              btree_gist:
                enabled: true
      cluster:
        enabled: true
        mode: bdr
        role: master
        members:
        - host: "172.16.10.101"
        - host: "172.16.10.102"
        - host: "172.16.10.101"
        local: "172.16.10.102"
        master: "172.16.10.101"
        replication_user:
          name: repuser
          password: password

Client
------

.. code-block:: yaml

    postgresql:
      client:
        server:
          server01:
            admin:
              host: database.host
              port: 5432
              user: root
              password: password
            database:
              mydb:
                enabled: true
                encoding: 'UTF8'
                locale: 'en_US'
                users:
                - name: test
                  password: test
                  host: localhost
                  createdb: true
                  rights: all privileges
                init:
                  maintenance_db: mydb
                  queries:
                  - INSERT INTO login VALUES (11, 1) ;
                  - INSERT INTO device VALUES (1, 11, 42);


Sample usage
============

Init database cluster with given locale

.. code-block:: bash

    sudo su - postgres -c "/usr/lib/postgresql/9.3/bin/initdb /var/lib/postgresql/9.3/main --locale=C"

Convert PostgreSQL cluster from 9.1 to 9.3

.. code-block:: bash

    sudo su - postgres -c '/usr/lib/postgresql/9.3/bin/pg_upgrade -b /usr/lib/postgresql/9.1/bin -B /usr/lib/postgresql/9.3/bin -d /var/lib/postgresql/9.1/main/ -D /var/lib/postgresql/9.3/main/ -O "-c config_file=/etc/postgresql/9.3/main/postgresql.conf" -o "-c config_file=/etc/postgresql/9.1/main/postgresql.conf"'

Ubuntu on 14.04 on some machines won't create default cluster

.. code-block:: bash

    sudo pg_createcluster 9.3 main --start


More information
================

* http://www.postgresql.org/
* http://www.postgresql.org/docs/9.1/interactive/index.html
* http://momjian.us/main/writings/pgsql/hw_performance/
* https://gist.github.com/ibussieres/11262268 - upgrade instructions for ubuntu


Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-postgresql/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-postgresql

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
