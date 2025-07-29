#!/bin/bash

# Куда сохраняем бэкап
BACKUP_DIR="/tmp/backup"
SOURCE_DIR="$HOME/"

# Проверяем, существует ли директория для бэкапа
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" || {
        logger -t "home_backup" "Ошибка: не удалось создать $BACKUP_DIR"
        exit 1
    }
fi

# Запускаем rsync
rsync -a --stats --checksum --delete "$SOURCE_DIR" "$BACKUP_DIR" >/dev/null 2>&1

# Проверяем код завершения rsync и пишем в syslog
if [ $? -eq 0 ]; then
    logger -t "home_backup" "Резервное копирование $SOURCE_DIR успешно завершено"
else
    logger -t "home_backup" "Ошибка резервного копирования $SOURCE_DIR!"
    exit 1
fi
