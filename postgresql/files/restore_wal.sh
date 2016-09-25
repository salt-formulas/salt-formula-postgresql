#!/bin/bash
{%- from "postgresql/map.jinja" import server with context %}
POSTGRESQL_DIR="/var/lib/pgsql/9.3";
POSTGRESQL_DATA_DIR="$POSTGRESQL_DIR/data"
BASE_DATA_PATH="barman_backups/WB_DEV/base/20160719T212002/pgdata"
WALS_DATA_PATH="barman_backups/WB_DEV/wals/0000000500000389"
POSTGRESQL_BIN="/usr/pgsql-9.3/bin"

echo "Running Postgresql server recovery"
echo "Creating necessary directories"

mkdir $POSTGRESQL_DIR/pgbackup
mkdir $POSTGRESQL_DIR/pgbackup/backup
mkdir $POSTGRESQL_DIR/pgbackup/wals
mkdir $POSTGRESQL_DIR/pgbackup/wals_orig

echo "Downloading base backup"
scp {{ server.initial_data.base_url }} $POSTGRESQL_DIR/pgbackup/backup/

echo "Dowloading wals"
scp {{ server.initial_data.wals_url }} $POSTGRESQL_DIR/pgbackup/wals_orig/

if [ "$(ls -A $POSTGRESQL_DATA_DIR)" ]; then
     echo "Cannot restore wal data, $POSTGRESQL_DATA_DIR is not empty"
     exit 1
else
    echo "Extracting base data"
    tar -xf $POSTGRESQL_DIR/pgbackup/backup/WB_DEV_base.tar -C $POSTGRESQL_DIR/pgbackup/backup/
    
    echo "Extracting wals"
    tar -xf $POSTGRESQL_DIR/pgbackup/wals_orig/WB_DEV_wals.tar -C $POSTGRESQL_DIR/pgbackup/wals_orig/

    echo "Moving extracted base data to Postgresql data folder"
    mv $POSTGRESQL_DIR/pgbackup/backup/$BASE_DATA_PATH/* $POSTGRESQL_DATA_DIR

    echo "Moving extracted wals data"
    mv $POSTGRESQL_DIR/pgbackup/wals_orig/$WALS_DATA_PATH/* $POSTGRESQL_DIR/pgbackup/wals/

    echo "Creating recovery.conf"
    echo "restore_command = 'cp $POSTGRESQL_DIR/pgbackup/wals/%f %p'" > $POSTGRESQL_DATA_DIR/recovery.conf

    echo "Changing permission to data folder"
    chown postgres:postgres -R $POSTGRESQL_DATA_DIR
    chmod 0700 -R $POSTGRESQL_DATA_DIR 

    echo "Changing permission to wals folder"
    chown postgres:postgres -R $POSTGRESQL_DIR/pgbackup/wals/
    chmod 0700 -R $POSTGRESQL_DIR/pgbackup/wals/

    echo "Running Postgresql server for recovery"
    sudo -u postgres $POSTGRESQL_BIN/pg_ctl start -D $POSTGRESQL_DATA_DIR > $POSTGRESQL_DIR/migrate.log 2>&1 &
    echo "Done, check Postgresql log"
    touch /root/postgresql/flags/restore_wal-done
    exit 0
fi


