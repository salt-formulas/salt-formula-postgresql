{%- from "postgresql/map.jinja" import client with context %}
{%- if client.get('enabled', True) %}

postgresql_client_packages:
  pkg.installed:
  - names: {{ client.pkgs }}

{%- for svr_name, svr in client.get('server', {}).items() %}
  {%- set admin = svr.get('admin', {}) %}
  {%- for database_name, database in svr.get('database', {}).items() %}
    {%- include "postgresql/_database.sls" %}
  {%- endfor %}
{%- endfor %}

{%- endif %}
