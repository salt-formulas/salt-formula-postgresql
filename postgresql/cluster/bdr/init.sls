{%- from "postgresql/map.jinja" import cluster with context %}

{%- if cluster.enabled %}
include:
{%- if cluster.get("role") == "master" %}
- postgresql.cluster.bdr.master
{% elif cluster.get("role") == "slave" %}
- postgresql.cluster.bdr.slave
{% endif %}
{% endif %}

