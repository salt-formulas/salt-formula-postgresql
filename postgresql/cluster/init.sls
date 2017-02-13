{%- from "postgresql/map.jinja" import cluster with context %}

{%- if cluster.enabled %}
include:
{%- if cluster.get("mode") == "hot_standby" %}
- postgresql.cluster.hot-standby
{% elif cluster.get("mode") == "bdr" %}
- postgresql.cluster.bdr
{% endif %}
{% endif %}
