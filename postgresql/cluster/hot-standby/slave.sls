{%- from "postgresql/map.jinja" import cluster with context %}

{%- if cluster.enabled %}

postgresql_slave_service_stop:
  service.dead:
  - name: {{ cluster.service }}
  - enable: true
  - unless: "[ -f {{ cluster.dir.data }}/cluster-created ]"
  - require:
    - pkg: postgresql_packages

clean_postgresql_data_dir:
  file.absent:
  - name: {{ cluster.dir.data }}
  - unless: "[ -f {{ cluster.dir.data }}/cluster-created ]"
  - require:
    - service: postgresql_slave_service_stop

postgresql_slave_dirs:
  file.directory:
  - names:
    - {{ cluster.dir.data }}
  - mode: 700
  - user: postgres
  - group: postgres
  - makedirs: true
  - require:
    - file: clean_postgresql_data_dir

restore_postgresql_cluster:
  cmd.run:
  - names:
    - pg_basebackup --host {{ cluster.master.host }} -U {{ cluster.master.user }} --xlog-method=stream -D {{ cluster.dir.data }} -w -d "password={{ cluster.master.password }}" -v && touch {{ cluster.dir.data }}/cluster-created
  - unless: "[ -f {{ cluster.dir.data }}/cluster-created ]"
  - user: postgres
  - cwd: /var/lib/postgresql
  - require:
    - file: postgresql_slave_dirs

{{ cluster.dir.data }}/postgresql.conf:
  file.managed:
  - source: salt://postgresql/files/{{ cluster.version }}/postgresql.conf.{{ grains.os_family }}
  - template: jinja
  - user: postgres
  - group: postgres
  - defaults:
      postgresql_version: {{ cluster.version }}
  - mode: 600
  - require:
    - cmd: restore_postgresql_cluster

{{ cluster.dir.data }}/recovery.conf:
  file.managed:
  - source: salt://postgresql/files/recovery.conf
  - template: jinja
  - user: postgres
  - group: postgres
  - mode: 600
  - require:
    - cmd: restore_postgresql_cluster

postgresql_slave_service:
  service.running:
  - name: {{ cluster.service }}
  - enable: true
  - watch:
    - file: {{ cluster.dir.data }}/postgresql.conf
    - file: {{ cluster.dir.data }}/recovery.conf
  - require:
    - cmd: restore_postgresql_cluster
    - file: {{ cluster.dir.data }}/recovery.conf

{%- endif %}

