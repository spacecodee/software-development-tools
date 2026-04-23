#!/bin/bash

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/../.env" ]; then
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        export "$key=$value"
    done < "$SCRIPT_DIR/../.env"
fi

SONAR_URL="http://localhost:${SONAR_PORT:-9000}"
DEFAULT_USER="admin"
DEFAULT_PASS="admin"

echo "Waiting for SonarQube to be ready at $SONAR_URL..."

# Wait for SonarQube to respond with status UP
until curl -s "$SONAR_URL/api/system/status" | grep -q '"status":"UP"'; do
    printf '.'
    sleep 5
done

echo -e "\nSonarQube is up!"

STATUS=$(curl -s -u "$DEFAULT_USER:$DEFAULT_PASS" "$SONAR_URL/api/system/status" | grep -o '"status":"UP"')

if [ "$STATUS" == '"status":"UP"' ]; then
    echo "Changing default admin password..."
    
    if curl -s -u "$DEFAULT_USER:$DEFAULT_PASS" -X POST \
        "$SONAR_URL/api/users/change_password?login=$SONAR_ADMIN_USER&previousPassword=$DEFAULT_PASS&password=$SONAR_ADMIN_PASSWORD"; then
        echo "Successfully updated SonarQube admin password!"
    else
        echo "Failed to update password. It might have been changed already."
    fi
else
    echo "SonarQube is not in UP status. Current status: $STATUS"
fi
