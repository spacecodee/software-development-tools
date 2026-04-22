#!/bin/bash
set -e

echo "Running init-db.sh for SonarQube..."
echo "Creating user: $SONAR_DB_USER and database: $SONAR_DB_NAME"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER "$SONAR_DB_USER" WITH PASSWORD '$SONAR_DB_PASSWORD';
	CREATE DATABASE "$SONAR_DB_NAME";
	GRANT ALL PRIVILEGES ON DATABASE "$SONAR_DB_NAME" TO "$SONAR_DB_USER";
    ALTER DATABASE "$SONAR_DB_NAME" OWNER TO "$SONAR_DB_USER";
EOSQL

echo "init-db.sh completed successfully."
