{%- from "postgresql/map.jinja" import cluster with context %}
{%- if cluster.enabled %}

postgresql_user_cluster_repuser:
  postgres_user.present:
  - name: {{ cluster.get("replication_user", {}).get("name", "repuser") }}
  - user: postgres
  - replication: True
  - password: {{ cluster.get("replication_user", {}).get("password") }}
  - require:
    - service: postgresql_service
    - pkg: postgresql_packages

postgresql_recovery_conf:
  file.absent:
  - name: {{ cluster.dir.data }}/recovery.conf
  - require:
    - service: postgresql_service
    - pkg: postgresql_packages

postgresql_master_service:
  service.running:
  - name: {{ cluster.service }}
  - enable: true
  - watch:
    - file: {{ cluster.dir.config }}/pg_hba.conf
    - file: {{ cluster.dir.config }}/postgresql.conf
  - require:
    - file: /root/.pgpass

{%- endif %}

