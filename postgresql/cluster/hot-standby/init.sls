{%- from "postgresql/map.jinja" import cluster with context %}

{%- if cluster.enabled %}
include:
{%- if cluster.get("role") == "master" %}
- postgresql.cluster.hot-standby.master
{% elif cluster.get("role") == "slave" %}
- postgresql.cluster.hot-standby.slave
{% endif %}
{% endif %}

