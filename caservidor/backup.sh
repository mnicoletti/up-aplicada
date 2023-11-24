#!/bin/bash
##Definimos las carpetas de origen y destino de los datos##
carpeta_origen="/media/data1"
carpeta_destino="/media/backups"

BACKUP_LOG="backup-data1.sh_$(date +'%Y-%m-%d_%H-%M-%SZ').log"

BACKUP_LOG_PATH="${BACKUP_HOME}/backup.sh.logs"

# Verifico la existencia del directorio de log.
if [[ ! -d ${BACKUP_HOME} ]]; then
    mkdir -p ${BACKUP_HOME}
fi

## Funcion de registro de log
log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $1" >> "${BACKUP_LOG}"
}

##Verificamos si tenemos un archivo de exclusión como argumento##
if [[ -n $1 ]]; then
    exclude_file="$1"
    exclude_option="--exclude-from=$exclude_file"
else
    exclude_option=""
fi

{
    echo "Comenzando copia de seguridad"
    log_message "Comenzando copia de seguridad"
    rsync -avz --delete --human-readable $exclude_option "$carpeta_origen/"
    "$carpeta_destino/"
    rsync_exit_code=$?
    
    if [[ $rsync_exit_code -eq 0 ]]; then
        echo "Copia de seguridad completa."
        log_message "Copia de seguridad completa."
    else
        echo "Error durante la copia. Código de salida de Rsync: $rsync_exit_code"
        log_message "Error durante la copia. Código de error re Rsync: $rsync_exit_code"
    fi
} 2>&1 | tee -a "${BACKUP_LOG}"