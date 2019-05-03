#!/bin/bash

FIND_PARAMETERS_DEFAULT="-name *.tar -o -name *.tar.gz"
ARCHIVEMOUNT_PARAMETERS_DEFAULT="-o ro"

SCRIPT_DIR_REL=`dirname "${BASH_SOURCE[0]}"`
SCRIPTS_DIR_ABS=`realpath -s "$SCRIPT_DIR_REL"`
source "$SCRIPTS_DIR_ABS/lib.bash"

ARCHIVES_SRC_DIR="$1"
if [ ! -d "$ARCHIVES_SRC_DIR" ]; then
  (echo >&2  "Archives source path is invalid.")
  exit 1
fi
ARCHIVES_SRC_DIR=`realpath -s "$ARCHIVES_SRC_DIR"`

MOUNT_DST_DIR="$2"
if [ ! -d "$MOUNT_DST_DIR" ]; then
  (echo >&2  "Mount destination path is invalid.")
  exit 1
fi
MOUNT_DST_DIR=`realpath -s "$MOUNT_DST_DIR"`

FIND_PARAMETERS="$3"
if [ -z "$FIND_PARAMETERS" ]; then
  FIND_PARAMETERS="$FIND_PARAMETERS_DEFAULT"
fi

ARCHIVEMOUNT_PARAMETERS="$4"
if [ -z "$ARCHIVEMOUNT_PARAMETERS" ]; then
  ARCHIVEMOUNT_PARAMETERS="$ARCHIVEMOUNT_PARAMETERS_DEFAULT"
fi



ARCHIVES_LIST=`find "$ARCHIVES_SRC_DIR" $FIND_PARAMETERS`
exitOnFail $? "find failed: $ARCHIVES_LIST. $MSG_SCRIPT_INTERRUPTING"
readarray -t ARCHIVES_LIST <<<"$ARCHIVES_LIST" \
    && declare -p ARCHIVES_LIST >/dev/null # https://stackoverflow.com/a/45201229

for CUR_ARCHIVE_FULLPATH in "${ARCHIVES_LIST[@]}"; do
    CUR_ARCHIVE_RELPATH=${CUR_ARCHIVE_FULLPATH#"$ARCHIVES_SRC_DIR"}
    CUR_MOUNT_PATH="$MOUNT_DST_DIR$CUR_ARCHIVE_RELPATH"

    echo "Process archive: $CUR_ARCHIVE_FULLPATH"
    echo "Mount point: $CUR_MOUNT_PATH"

    MKDIR_OUTPUT=`mkdir -p "$CUR_MOUNT_PATH"`
    exitOnFail $? "mkdir dst dir failed: $MKDIR_OUTPUT. $MSG_SCRIPT_INTERRUPTING"

    ARCHIVEMOUNT_OUTPUT=`archivemount $ARCHIVEMOUNT_PARAMETERS "$CUR_ARCHIVE_FULLPATH" "$CUR_MOUNT_PATH"`
    exitOnFail $? "archivemount failed: $ARCHIVEMOUNT_OUTPUT. $MSG_SCRIPT_INTERRUPTING"
    echo -e "\n\n"
done