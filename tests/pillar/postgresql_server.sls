postgresql:
  server:
    clients:
    - 127.0.0.1
    bind:
      address: 127.0.0.1
      port: 5432
      protocol: tcp
    enabled: true
    database:
      testing:
        enabled: true
        encoding: 'UTF8'
        locale: 'en_US'
        users:
        - name: test
          password: test
          host: localhost
          createdb: true
          rights: all privileges
    settings:
      max_connections: 300
      timezone: "'UTC'"
    hba_records:
      - 'host   all    all    192.168.0.101/32   trust'
      - 'host   all    all    0.0.0.0/0   md5'
