
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
