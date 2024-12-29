#!/usr/bin/env bash
ENV_FILE="/tmp/db_seed/.env"
# Check if the file exists
if [ -f "$ENV_FILE" ]; then
  # Source the file
  source "$ENV_FILE"
  echo "Sourced $FILE_TO_SOURCE"
fi

# Define database credentials and database name


# Drop and recreate the database
mysql -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" -e "
DROP DATABASE IF EXISTS \`$DB_NAME\`;
CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
"
mysql -u syslog_user -p syslog < /tmp/db_import/db_seed.sql