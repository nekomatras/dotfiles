#!/bin/bash

# rclone mount gdrive:Shared/SharedContent ~/Desktop/Shared/Remote/
# rclone mount gdrive:Shared/SharedBackup ~/Desktop/Shared/RemoteBackup/

#Usage: ./sync.sh ~/Desktop/Shared/Local ~/Desktop/Shared/Remote ~/Desktop/Shared/Backup ~/Desktop/Shared/RemoteBackup

# Check arguments number
if [ $# -ne 4 ]; then
    echo "Usage: $0 <LOCAL_DIR> <REMOTE_DIR> <LOCAL_BACKUP_DIR> <REMOTE_BACKUP_DIR>"
    exit 1
fi

REMOTE_CONTENT_SOURCE="gdrive:Shared/SharedContent"
REMOTE_BACKUP_SOURCE="gdrive:Shared/SharedBackup"
LOCAL_BACKUP_REMOTE_DIR="LocalBackup-$(hostnamectl --static)"

# Set directories
LOCAL_DIR="$1"
REMOTE_DIR="$2"
LOCAL_BACKUP_DIR="$3"
REMOTE_BACKUP_DIR="$4"

echo "Local folder: $LOCAL_DIR"
echo "Local backup folder: $LOCAL_BACKUP_DIR"
echo "Remote folder: $REMOTE_DIR"
echo "Remote backup folder: $REMOTE_BACKUP_DIR"

###
check

backup_files "$LOCAL_DIR" "$LOCAL_BACKUP_DIR"
backup_files "$REMOTE_DIR" "$REMOTE_BACKUP_DIR"

copy_remote_to_local
copy_local_to_remote

copy_local_backup_to_remote
###

get_mounted_source() {
    local target="$1"

    if ! findmnt -n -o SOURCE "$target"; then
        echo "Unable to get mounted source from $1"
        exit 1
    fi

    local source=$(findmnt -n -o SOURCE "$target")

    if [ "$source" != "" ]; then
        return $source
    else
        echo "Target [$target] is not mounted"
        exit 1
    fi
}

check() {
    # Check mount targets
    local content_source=$(get_mounted_source "$REMOTE_DIR")
    if [ "$content_source" != "$REMOTE_CONTENT_SOURCE" ]; then
        echo "Error: $REMOTE_DIR not mounted to $REMOTE_CONTENT_SOURCE!"
        exit 1
    else
        echo "$REMOTE_DIR mounted to $REMOTE_CONTENT_SOURCE"
    fi

    local backup_source=$(get_mounted_source "$REMOTE_BACKUP_DIR")
    if [ "$backup_source" != "$REMOTE_BACKUP_SOURCE" ]; then
        echo "Error: $REMOTE_BACKUP_DIR not mounted to $REMOTE_BACKUP_SOURCE!"
        exit 1
    else
        echo "$REMOTE_BACKUP_DIR mounted to $REMOTE_BACKUP_SOURCE"
    fi

    # Check opened files in local folder
    if lsof +D "$LOCAL_DIR" >/dev/null 2>&1; then
        echo "There is an open file in: $LOCAL_DIR\nReturn..."
        exit 1
    else
        echo "There is no open files in: $LOCAL_DIR."
    fi

    # Check if backup folder exists
    if [ ! -d "$LOCAL_DIR/$LOCAL_BACKUP_DIR" ]; then
        echo "There is no backup folder: $LOCAL_DIR/$LOCAL_BACKUP_DIR\nCreateing..."
        mkdir -p "$LOCAL_DIR" || { echo "Unable to create $LOCAL_DIR"; exit 1; }
    fi
}

#Usage: backup_files <SOURCE_DIR> <TARGET_DIR>
#Example: backup_files "$LOCAL_DIR" "$LOCAL_BACKUP_DIR"
backup_files() {
    local source_dir=$1
    local target_dir=$2

    # Select archive name
    local timestamp=$(date +"%d-%m-%Y_%H:%M:%S")
    local backup_target_name="$target_dir/Backup-$timestamp"
    local backup_target_archive="$backup_target_dir.7z"

    if [ ! -f "$backup_target_archive" ]; then
        echo "Create backup: $backup_target_archive"
    else
        backup_target_archive="$backup_target_name-$(date +%s%N).7z"
        echo "Create backup: $backup_target_archive"
    fi

    echo "Backup $source_dir to $backup_target_archive"

    echo "List: $source_dir"
    ls -lh "$source_dir/"
    echo "------------"

    echo "Compress $backup_target_archive"
    7z a -t7z -mx=9 "$backup_target_archive" "$source_dir" || { echo "Unable to archive: $source_dir -> $backup_target_archive"; exit 1; }

    echo "List: $backup_target_archive"
    7z l "$backup_target_archive" || { echo "Unable to list content in archive: $backup_target_archive"; exit 1; }
    echo "------------"
}

copy_local_backup_to_remote() {
    local local_remote_dir="$REMOTE_BACKUP_DIR/$LOCAL_BACKUP_REMOTE_DIR"
    mkdir -p "$local_remote_dir"
    echo "Copy backup to remote [$LOCAL_BACKUP_DIR -> $local_remote_dir ($(get_mounted_source "$REMOTE_BACKUP_DIR")/$LOCAL_BACKUP_REMOTE_DIR)]"
    cp -rfu "$LOCAL_BACKUP_DIR/*" "$local_remote_dir/" || { echo "Unable to copy: $LOCAL_DIR/* -> $local_remote_dir/"; exit 1; }
}

sync_local_to_remote() {
    echo "Sync: $LOCAL_DIR -> $REMOTE_CONTENT_SOURCE"

    echo "List remote before: $REMOTE_DIR"
    ls -lh "$REMOTE_DIR/"
    echo "------------"

    rclone sync "$LOCAL_DIR" "$REMOTE_CONTENT_SOURCE" || { echo "Unable to sync: $LOCAL_DIR -> $REMOTE_CONTENT_SOURCE"; exit 1; }

    echo "List remote after: $REMOTE_DIR"
    ls -lh "$REMOTE_DIR/"
    echo "------------"
}

sync_remote_to_local() {
    echo "Sync: $REMOTE_CONTENT_SOURCE -> $LOCAL_DIR"

    echo "List local before: $LOCAL_DIR"
    ls -lh "$LOCAL_DIR/"
    echo "------------"

    rclone sync "$REMOTE_CONTENT_SOURCE" "$LOCAL_DIR" || { echo "Unable to sync: $REMOTE_CONTENT_SOURCE -> $LOCAL_DIR"; exit 1; }

    echo "List local after: $LOCAL_DIR"
    ls -lh "$LOCAL_DIR/"
    echo "------------"
}

copy_local_to_remote() {
    echo "Copy $LOCAL_DIR/* to $REMOTE_DIR/"

    echo "List remote before: $REMOTE_DIR"
    ls -lh "$REMOTE_DIR/"
    echo "------------"

    cp -rfu "$LOCAL_DIR/*" "$REMOTE_DIR/" || { echo "Unable to copy: $LOCAL_DIR/* -> $REMOTE_DIR/"; exit 1; }

    echo "List remote after: $REMOTE_DIR"
    ls -lh "$REMOTE_DIR/"
    echo "------------"
}

copy_remote_to_local() {
    echo "Copy $REMOTE_DIR/* to $LOCAL_DIR/"

    echo "List local before: $LOCAL_DIR"
    ls -lh "$LOCAL_DIR/"
    echo "------------"

    cp -rfu "$REMOTE_DIR/*" "$LOCAL_DIR/" || { echo "Unable to copy: $REMOTE_DIR/* -> $LOCAL_DIR/"; exit 1; }

    echo "List local after: $LOCAL_DIR"
    ls -lh "$LOCAL_DIR/"
    echo "------------"
}