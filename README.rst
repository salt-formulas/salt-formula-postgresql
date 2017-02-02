
==========
PostgreSQL
==========

PostgreSQL, often simply Postgres, is an object-relational database management system available for many platforms including Linux, FreeBSD, Solaris, Microsoft Windows and Mac OS X. It is released under the PostgreSQL License, which is an MIT-style license, and is thus free and open source software. PostgreSQL is developed by the PostgreSQL Global Development Group, consisting of a handful of volunteers employed and supervised by companies such as Red Hat and EnterpriseDB.

Support
=======

* required by: [redmine](../master/redmine)
* service versions: 9.1
* operating systems: Ubuntu 12.04

Sample pillars
==============

Single database server with empty database
------------------------------------------

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
          name: 'databasename'
          encoding: 'UTF8'
          locale: 'cs_CZ'
          user:
            name: 'username'
            password: 'password'
            host: 'localhost'
            rights: 'all privileges'

Single database server with prepopulated database
-------------------------------------------------

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
          name: 'databasename'
          encoding: 'UTF8'
          locale: 'cs_CZ'
          initial_data:
            engine: backupninja
            source: backup.host
            host: original-host-name
            database: original-database-name
          user:
            name: 'username'
            password: 'password'
            host: 'localhost'
            rights: 'all privileges'

User with createdb privileges
-----------------------------

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
          name: 'databasename'
          encoding: 'UTF8'
          locale: 'cs_CZ'
          user:
            name: 'username'
            password: 'password'
            host: 'localhost'
            createdb: true
            rights: 'all privileges'


PostgreSQL extensions
---------------------

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
          name: 'databasename'
          encoding: 'UTF8'
          locale: 'cs_CZ'
          user:
            name: 'username'
            password: 'password'
            host: 'localhost'
            createdb: true
            rights: 'all privileges'
          extension:
            postgis_topology:
            fuzzystrmatch:
            postgis_tiger_geocoder:
            postgis:

## Sample usage

Init database cluster with given locale

    sudo su - postgres -c "/usr/lib/postgresql/9.3/bin/initdb /var/lib/postgresql/9.3/main --locale=C"

Convert PostgreSQL cluster from 9.1 to 9.3

    sudo su - postgres -c '/usr/lib/postgresql/9.3/bin/pg_upgrade -b /usr/lib/postgresql/9.1/bin -B /usr/lib/postgresql/9.3/bin -d /var/lib/postgresql/9.1/main/ -D /var/lib/postgresql/9.3/main/ -O "-c config_file=/etc/postgresql/9.3/main/postgresql.conf" -o "-c config_file=/etc/postgresql/9.1/main/postgresql.conf"'

Ubuntu on 14.04 on some machines won't create default cluster

    sudo pg_createcluster 9.3 main --start

## Read more

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
