postgresql:
  client:
    enabled: true
    server:
      server01:
        admin:
          host: database.host
          port: 5432
          user: root
          password: password
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
