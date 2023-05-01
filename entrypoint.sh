#!/bin/bash

FOLDER=$1
EXCLUDE=$2
echo "searching for non-CRLF line endings in: $FOLDER"

FILES_TYPES="$(find "$FOLDER" ! -path "./.git/*" -not -type d -exec file "{}" ";")"
FILES_WITHOUT_CRLF=$(echo "$FILES_TYPES" | grep -v " CRLF " | cut -d " " -f 1 | cut -d ":" -f 1)

for word in $EXCLUDE; do
  FILES_WITHOUT_CRLF=$(echo "$FILES_WITHOUT_CRLF" | grep --invert-match -E "$word")
done

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

if [ -z "$FILES_WITHOUT_CRLF" ]; then
  echo -e "${BOLD_GREEN}No files with non-CRLF line endings found.${NO_COLOR}"
  exit 0
else
  NR_FILES=$(echo "$FILES_WITHOUT_CRLF" | wc -l)
  echo -e "${BOLD_RED}Found ${NR_FILES} files with non-CRLF line endings.${NO_COLOR}"
  echo "$FILES_WITHOUT_CRLF"
  exit "$NR_FILES"
fi
