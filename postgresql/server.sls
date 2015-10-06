{%- from "postgresql/map.jinja" import server with context %}
{%- if server.enabled %}

postgresql_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

init_postgresql_cluster:
  cmd.run:
  - name: pg_createcluster {{ server.version }} main --start
  - unless: "[ -f /etc/postgresql/{{ server.version }}/main/postgresql.conf ]"
  - cwd: /root
  - require:
    - pkg: postgresql_packages

/etc/postgresql/{{ server.version }}/main/pg_hba.conf:
  file.managed:
  - source: salt://postgresql/files/pg_hba.conf
  - template: jinja
  - user: postgres
  - group: postgres
  - mode: 600
  - require:
    - pkg: postgresql_packages

/etc/postgresql/{{ server.version }}/main/postgresql.conf:
  file.managed:
  - source: salt://postgresql/files/{{ server.version }}/postgresql.conf
  - template: jinja
  - user: postgres
  - group: postgres
  - defaults:
    postgresql_version: {{ server.version }}
  - mode: 600
  - require:
    - pkg: postgresql_packages

/root/.pgpass:
  file.managed:
  - source: salt://postgresql/files/pgpass
  - template: jinja
  - user: root
  - group: root
  - mode: 600
  - require:
    - pkg: postgresql_packages

postgresql_service:
  service.running:
  - name: postgresql
  - watch:
    - file: /etc/postgresql/{{ server.version }}/main/pg_hba.conf
    - file: /etc/postgresql/{{ server.version }}/main/postgresql.conf
  - require:
    - file: /root/.pgpass

postgresql_dirs:
  file.directory:
  - names:
    - /root/postgresql/backup
    - /root/postgresql/flags
    - /root/postgresql/data
    - /root/postgresql/scripts
  - mode: 700
  - user: root
  - group: root
  - makedirs: true
  - require:
    - pkg: postgresql_packages


{%- for database in server.get('databases', []) %}

{%- for user in database.users %}

postgresql_user_{{ database.name }}_{{ user.name }}:
  postgres_user.present:
  - name: {{ user.name }}
  - user: postgres
  {% if user.get('createdb', False) %}
  - createdb: enabled
  {% endif %}
  - password: {{ user.password }}
  - require:
    - service: postgresql_service

{%- endfor %}

postgresql_database_{{ database.name }}:
  postgres_database.present:
  - name: {{ database.name }}
  - encoding: {{ database.encoding }}
  - user: postgres
  - template: template0
  - owner: {% for user in database.users %}{% if loop.first %}{{ user.name }}{% endif %}{% endfor %}
  - require:
    {%- for user in database.users %}
    - postgres_user: postgresql_user_{{ database.name }}_{{ user.name }}
    {%- endfor %}

{% if database.initial_data is defined %}

{%- set engine = database.initial_data.get("engine", "backupninja") %}

/root/postgresql/scripts/restore_{{ database.name }}.sh:
  file.managed:
  - source: salt://postgresql/files/restore.sh
  - mode: 770
  - template: jinja
  - defaults:
    database_name: {{ database.name }}
  - require: 
    - file: postgresql_dirs
    - postgres_database: postgresql_database_{{ database.name }}

restore_postgresql_database_{{ database.name }}:
  cmd.run:
  - name: /root/postgresql/scripts/restore_{{ database.name }}.sh
  - unless: "[ -f /root/postgresql/flags/{{ database.name }}-installed ]"
  - cwd: /root
  - require:
    - file: /root/postgresql/scripts/restore_{{ database.name }}.sh

{% endif %}

{%- endfor %}

{%- for database_name, database in server.get('database', {}).iteritems() %}

{%- for user in database.users %}

postgresql_user_{{ database_name }}_{{ user.name }}:
  postgres_user.present:
  - name: {{ user.name }}
  - user: postgres
  {% if user.get('createdb', False) %}
  - createdb: enabled
  {% endif %}
  - password: {{ user.password }}
  - require:
    - service: postgresql_service

{%- endfor %}

postgresql_database_{{ database_name }}:
  postgres_database.present:
  - name: {{ database_name }}
  - encoding: {{ database.encoding }}
  - user: postgres
  - template: template0
  - owner: {% for user in database.users %}{% if loop.first %}{{ user.name }}{% endif %}{% endfor %}
  - require:
    {%- for user in database.users %}
    - postgres_user: postgresql_user_{{ database_name }}_{{ user.name }}
    {%- endfor %}

{%- if database.extension is defined %}

postgresql_extensions_packages:
  pkg.installed:
  - names:
    - postgresql-{{ server.version }}-postgis-2.1
  - skip_suggestions: True
  - skip_verify: True

{%- endif %}

{%- for extension_name, extension in database.get('extension', {}).iteritems() %}

database_{{ database_name }}_{{ extension_name }}_extension:
  postgres_extension.present:
  - name: {{ extension_name }}
  - maintenance_db: {{ database_name }}
  - user: postgres
  - template: template0
  - require:
    - postgres_database: postgresql_database_{{ database_name }}
{%- endfor %}

{% if database.initial_data is defined %}

{%- set engine = database.initial_data.get("engine", "backupninja") %}

/root/postgresql/scripts/restore_{{ database_name }}.sh:
  file.managed:
  - source: salt://postgresql/files/restore.sh
  - mode: 770
  - template: jinja
  - defaults:
    database_name: {{ database_name }}
  - require: 
    - file: postgresql_dirs
    - postgres_database: postgresql_database_{{ database_name }}

restore_postgresql_database_{{ database_name }}:
  cmd.run:
  - name: /root/postgresql/scripts/restore_{{ database_name }}.sh
  - unless: "[ -f /root/postgresql/flags/{{ database_name }}-installed ]"
  - cwd: /root
  - require:
    - file: /root/postgresql/scripts/restore_{{ database_name }}.sh

{% endif %}

{%- endfor %}

{%- endif %}
