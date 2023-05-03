#!/bin/bash
# Database Backup Script

# Set variables
DATEBCK=$(date +%Y%m%d)
SRV=$(hostname)
DB_TYPE=mysql
. /root/info/mysql.info

# MySQL options:
# -f, --force Continue even if we get an SQL error.
# -c, --complete-insert Use complete insert statements.
# -C, --compress Use compression in server/client protocol.
# -A, --all-databases Dump all the databases. This will be same as --databases with all databases selected.
# -l, --lock-tables Lock all tables for read.

# Start the database backup process
echo "Starting database backup..."
mysqldump --events -f -c -C -A -h localhost -u root $PASSWD -l | gzip > "/srv/mysql-$SRV-$DATEBCK.sql.gz"
echo "Database backup completed."

