#!/usr/bin/env bash
ENV_FILE="/"
# Check if the file exists
if [ -f "$ENV_FILE" ]; then
  # Source the file
  source "$ENV_FILE"
  echo "Sourced $FILE_TO_SOURCE"
fi
mysql -u syslog_user -p syslog < /tmp/db_import/db_seed.sql