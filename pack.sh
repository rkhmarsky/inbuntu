#!/usr/bin/env bash

# Завершить выполнение при возникновении любой ошибки
set -e

# Прочитать переменные из vars
. vars

# Применить модификации поверх файлов из
# оригинального ISO
rsync -a ./project/ISO/ ./ISO/

# Пересчитать хеш-суммы
cd ISO
find . -type f -print0 |
    xargs -0 md5sum |
    grep -v "boot.cat" |
    grep -v "md5sum.txt" > md5sum.txt
cd ..

# Создать кастомизированный ISO
xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "CDROM" \
  -eltorito-boot isolinux/isolinux.bin \
  -eltorito-catalog isolinux/boot.cat \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -isohybrid-mbr "$MBR" \
  -output "$INTIME_IMAGE" ISO
