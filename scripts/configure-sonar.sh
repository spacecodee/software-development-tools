#!/bin/bash

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/../.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/../.env" | xargs)
fi

SONAR_URL="http://localhost:${SONAR_PORT:-9000}"
DEFAULT_USER="admin"
DEFAULT_PASS="admin"

echo "Waiting for SonarQube to be ready at $SONAR_URL..."

# Wait for SonarQube to respond
until $(curl --output /dev/null --silent --head --fail "$SONAR_URL/api/system/status"); do
    printf '.'
    sleep 5
done

echo -e "\nSonarQube is up! Checking status..."

STATUS=$(curl -s -u "$DEFAULT_USER:$DEFAULT_PASS" "$SONAR_URL/api/system/status" | grep -o '"status":"UP"')

if [ "$STATUS" == '"status":"UP"' ]; then
    echo "Changing default admin password..."
    
    RESPONSE=$(curl -s -u "$DEFAULT_USER:$DEFAULT_PASS" -X POST \
        "$SONAR_URL/api/users/change_password?login=$SONAR_ADMIN_USER&previousPassword=$DEFAULT_PASS&password=$SONAR_ADMIN_PASSWORD")
    
    if [ $? -eq 0 ]; then
        echo "Successfully updated SonarQube admin password!"
    else
        echo "Failed to update password. It might have been changed already."
    fi
else
    echo "SonarQube is not in UP status. Current status: $STATUS"
fi
