#!/usr/bin/env bash

# Завершить выполнение при возникновении любой ошибки
set -e

# Прочитать переменные из vars
. vars

# Если нет оригинального ISO
if [[ ! -f $IMAGE ]]; then
    # скачать с оф. сайта
    curl -o "$IMAGE" -L "$UPSTREAM"
    # проверить хешсумму
    sha1sum -c SHA1SUMS
fi

# Если нет MBR
if [[ ! -f $MBR ]]; then
    # создать из оригинального ISO
    dd if="$IMAGE" of="$MBR" bs=512 count=1
fi

# Удалить рабочую директорию
rm -rf ISO
# Примонтировать оригинальный ISO
fuseiso -p "$IMAGE" mount
# Скопировать файлы из оригинального ISO
rsync -a mount/ ISO/
# Разрешить редактирование всех файлов
chmod -R u+w ISO
# Размонтировать оригинальный ISO
fusermount -u mount
