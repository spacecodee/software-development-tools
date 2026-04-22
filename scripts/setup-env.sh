#!/bin/bash

# Function to generate a random string
# Usage: generate_random <length>
generate_random() {
    LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c "$1"
}

# Function to generate a random password
# Usage: generate_password <length>
generate_password() {
    LC_ALL=C tr -dc 'A-Za-z0-9!#%^&*()-_=+' < /dev/urandom | head -c "$1"
}

echo "Generating secure credentials..."

# Random usernames (min 6 chars)
POSTGRES_USER=$(generate_random 10)
SONAR_DB_USER=$(generate_random 10)

# Secure passwords
POSTGRES_PASSWORD=$(generate_password 24)
PGADMIN_DEFAULT_PASSWORD=$(generate_password 16)
SONAR_DB_PASSWORD=$(generate_password 24)
SONAR_ADMIN_PASSWORD=$(generate_password 20)

# Define file paths relative to script location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
EXAMPLE_FILE="$SCRIPT_DIR/../.env.example"

# Create .env from .env.example if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    cp "$EXAMPLE_FILE" "$ENV_FILE"
fi

# Ensure all keys from .env.example exist in .env
while IFS='=' read -r key value; do
    if [[ ! $key =~ ^# && -n $key ]]; then
        if ! grep -q "^$key=" "$ENV_FILE"; then
            echo "$key=$value" >> "$ENV_FILE"
        fi
    fi
done < "$EXAMPLE_FILE"

# Update .env with generated values (compatible with BSD/macOS and GNU sed)
sed -i.bak \
    -e "s/^POSTGRES_USER=.*/POSTGRES_USER=$POSTGRES_USER/" \
    -e "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$POSTGRES_PASSWORD/" \
    -e "s/^PGADMIN_DEFAULT_PASSWORD=.*/PGADMIN_DEFAULT_PASSWORD=$PGADMIN_DEFAULT_PASSWORD/" \
    -e "s/^SONAR_DB_USER=.*/SONAR_DB_USER=$SONAR_DB_USER/" \
    -e "s/^SONAR_DB_PASSWORD=.*/SONAR_DB_PASSWORD=$SONAR_DB_PASSWORD/" \
    -e "s/^SONAR_ADMIN_PASSWORD=.*/SONAR_ADMIN_PASSWORD=$SONAR_ADMIN_PASSWORD/" \
    "$ENV_FILE" && rm "${ENV_FILE}.bak"

echo "Credentials generated and updated in $ENV_FILE"
echo "Postgres User: $POSTGRES_USER"
echo "Sonar DB User: $SONAR_DB_USER"
echo "Check $ENV_FILE for all updated credentials."
