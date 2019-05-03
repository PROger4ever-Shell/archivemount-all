#!/bin/bash

MSG_SCRIPT_INTERRUPTING="The script is going to be interrupted."
MSG_ERROR_PREFIX="Something went wrong during"

function handleFail() {
  local EXIT_STATUS=$1;
  local MSG="$2";

  if [ $EXIT_STATUS -eq 0 ]; then
    return 0;
  fi;

  # printing? cleaning?
  if [ -n "$MSG" ]; then
      (echo -e >&2 "\n\n=== $MSG");
  fi

  return 3;
}

function exitOnFail() {
  local EXIT_STATUS=$1;
  local MSG="$2";

  handleFail $EXIT_STATUS "$MSG";

  local EXIT_STATUS=$?;
  if [ $EXIT_STATUS -eq 0 ]; then
    return
  fi;
  exit $EXIT_STATUS
}

SCRIPT_DIR_REL=`dirname "${BASH_SOURCE[0]}"`
SCRIPTS_DIR_ABS=`realpath -s "$SCRIPT_DIR_REL"`
REPO_PATH=`realpath -s "$SCRIPTS_DIR_ABS/../.."`