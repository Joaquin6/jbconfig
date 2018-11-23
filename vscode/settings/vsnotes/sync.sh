#!/bin/sh
set -e # Exit on first error

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

logger() {
	echo "${BLUE}[VSNOTES-SYNC]${NO_COLOR}\t$1"
}

exit_sync() {
  local EXIT_CODE=${1:-0}

  echo "\n\n";
  exit $EXIT_CODE;
}

if [ ! -d ~/Dropbox ]; then
  logger "Dropbox is not installed or couldnt locate the storage directory"
  exit_sync 1
fi

if [ -d ~/Dropbox/joaquin/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Notes ]; then
  logger "Detected Sublime Text 3 Notes from Dropbox"
fi

