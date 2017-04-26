{%- for user in database.users %}
{% if not grains.get('noservices', False) %}
postgresql_user_{{ svr_name|default('localhost') }}_{{ database_name }}_{{ user.name }}:
  postgres_user.present:
    - name: {{ user.name }}
    - user: postgres
    {% if user.get('createdb', False) %}
    - createdb: enabled
    {% endif %}
    - password: {{ user.password }}
    {%- if server is defined %}
    - require:
        - service: postgresql_service
    {%- endif %}
    {%- if admin is defined %}
    {%- for k, p in admin.iteritems() %}
    - db_{{ k }}: {{ p }}
    {%- endfor %}
    - user: root
    {%- endif %}
{%- endif %}
{%- endfor %}

{% if not grains.get('noservices', False) %}
postgresql_database_{{ svr_name|default('localhost') }}_{{ database_name }}:
  postgres_database.present:
    - name: {{ database.get('name', database_name) }}
    - encoding: {{ database.encoding }}
    - user: postgres
    {%- if database.template is defined %}
    - template: {{ database.template }}
    {%- endif %}
    - owner: {% for user in database.users %}{% if loop.first %}{{ user.name }}{% endif %}{% endfor %}
    - require:
        {%- for user in database.users %}
        - postgres_user: postgresql_user_{{ svr_name|default('localhost') }}_{{ database_name }}_{{ user.name }}
        {%- endfor %}
    {%- if admin is defined %}
    {%- for k, p in admin.iteritems() %}
    - db_{{ k }}: {{ p }}
    {%- endfor %}
    - user: root
    {%- endif %}
{%- endif %}

{%- if database.initial_data is defined %}

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

{% if not grains.get('noservices', False) %}
restore_postgresql_database_{{ database_name }}:
  cmd.run:
    - name: /root/postgresql/scripts/restore_{{ database_name }}.sh
    - unless: "[ -f /root/postgresql/flags/{{ database_name }}-installed ]"
    - cwd: /root
    - require:
        - file: /root/postgresql/scripts/restore_{{ database_name }}.sh
{%- endif %}

{%- endif %}
