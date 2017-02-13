
include:
{% if pillar.postgresql.server is defined %}
- postgresql.server
{% endif %}
{% if pillar.postgresql.cluster is defined %}
- postgresql.cluster
{% endif %}
