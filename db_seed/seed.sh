#!/usr/bin/env bash
ENV_FILE="/tmp/db_seed/.env"
# Check if the file exists
if [ -f "$ENV_FILE" ]; then
  # Source the file
  source "$ENV_FILE"
  echo "Sourced Env"
fi
# Drop and recreate the database
echo "drop previous db"
/usr/bin/mariadb -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" -e "
DROP DATABASE IF EXISTS $DB_NAME;
"
echo "recreate db"
/usr/bin/mariadb -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" -e "
CREATE DATABASE $DB_NAME;
"
echo "reimport database"
/usr/bin/mariadb -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" -D "$DB_NAME" < /tmp/db_seed/db_seed.sql
echo "reinforce FK's"
/usr/bin/mariadb -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" -D "$DB_NAME" < /tmp/db_seed/1fk_events.sql;