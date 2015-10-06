
include:
{% if pillar.postgresql.server is defined %}
- postgresql.server
{% endif %}
