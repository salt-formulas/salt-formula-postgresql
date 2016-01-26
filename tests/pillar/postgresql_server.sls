postgresql:
  server:
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
          rights: all privileges
