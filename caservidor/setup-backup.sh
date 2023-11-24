#!/bin/bash
BACKUP_SCRIPT="/usr/local/aplicada/up-aplicada/caservidor/backup.sh"
BACKUP_HOME="/home/caadmin/backup-data1.sh"

ln -s ${BACKUP_SCRIPT} ${BACKUP_HOME}

# Creacion de crontab
echo "*/5 * * * * ${BACKUP_HOME} > /dev/null 2>&1" >> /var/spool/cron/crontabs/root