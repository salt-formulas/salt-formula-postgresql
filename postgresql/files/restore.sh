#!/bin/sh

cd /root/postgresql

{%- for database in pillar.postgresql.server.get("databases", []) %}
{%- if database.name == database_name %}

{%- set age = database.initial_data.get("age", "0") %}
{%- set host = database.initial_data.get("host", grains.id ) %}
{%- set name = database.initial_data.get("name", database.initial_data.get("database", database.name)) %}
{%- set source_name = name + ".pg_dump.gz" %}
{%- set dest_name = database.name + ".pg_dump.gz" %}
{%- set target = "/root/postgresql/data/" %}

scp backupninja@{{ database.initial_data.source }}:/srv/backupninja/{{ host }}/var/backups/postgresql/postgresql.{{ age }}/{{ source_name }} {{ target }}{{ dest_name }} 

gunzip -d -1 -f {{ target }}{{ dest_name }}

pg_restore /root/postgresql/data/{{ database.name }}.pg_dump --dbname={{ database.name }} --host=localhost --username={{ database.users[0].name }} --no-password -c

touch /root/postgresql/flags/{{ database.name }}-installed

{%- endif %}
{%- endfor %}

{%- for db_name,database in pillar.postgresql.server.get("database", {}).items() %}
{%- if db_name == database_name %}

{%- set age = database.initial_data.get("age", "0") %}
{%- set host = database.initial_data.get("host", grains.id ) %}
{%- set name = database.initial_data.get("name", database.initial_data.get("database", db_name)) %}
{%- set source_name = name + ".pg_dump.gz" %}
{%- set dest_name = db_name + ".pg_dump.gz" %}
{%- set target = "/root/postgresql/data/" %}

scp backupninja@{{ database.initial_data.source }}:/srv/backupninja/{{ host }}/var/backups/postgresql/postgresql.{{ age }}/{{ source_name }} {{ target }}{{ dest_name }} 

gunzip -d -1 -f {{ target }}{{ dest_name }}

pg_restore /root/postgresql/data/{{ db_name }}.pg_dump --dbname={{ db_name }} --host=localhost --username={{ database.users[0].name }} --no-password -c

touch /root/postgresql/flags/{{ db_name }}-installed

{%- endif %}
{%- endfor %}
