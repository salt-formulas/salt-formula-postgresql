{%- from "postgresql/map.jinja" import server, cluster with context %}
{%- if cluster.enabled %}

{%- set repuser_name = cluster.get("replication_user", {}).get("name", "repuser") %}
{%- set repuser_password = cluster.get("replication_user", {}).get("password") %}

postgresql_user_cluster_repuser:
  postgres_user.present:
  - name: {{ repuser_name }}
  - user: postgres
  - replication: True
  - superuser: True
  - password: {{ repuser_password }}
  - require:
    - service: postgresql_service
    - pkg: postgresql_packages

{%- set nodename = salt.grains.get('nodename') %}

{%- for database_name, database in server.get('database', {}).items() %}
bdr_group_create_{{ database_name }}:
  module.run:
    - name: postgres.psql_query
    - query: SELECT bdr.bdr_group_create(local_node_name := '{{ nodename }}', node_external_dsn := 'host={{ cluster.get("local") }} user={{ repuser_name }} password={{ repuser_password }} dbname={{ database_name }}');
    - user: postgres
    - maintenance_db: {{ database_name }}
    - unless: sudo -H -u postgres bash -c 'timeout 10s psql {{ database_name }} -c "SELECT bdr.bdr_node_join_wait_for_ready();"'
    - require:
      - postgres_user: postgresql_user_cluster_repuser
{%- endfor %}

{%- endif %}

