#!/bin/bash

# Определяем директорию, где лежит сам скрипт
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Целевая директория для шрифтов
TARGET_DIR="/usr/share/fonts"

# Проходим по всем файлам в папке скрипта
for file in "$SCRIPT_DIR"/*; do
    # Пропускаем сам скрипт
    [ "$file" = "$0" ] && continue

    # Имя файла
    filename="$(basename "$file")"

    # Создаём символическую ссылку
    ln -sf "$file" "$TARGET_DIR/$filename"
done
