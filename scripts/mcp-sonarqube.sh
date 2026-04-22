#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

# Securely extract the token from the .env file
# This avoids issues with special characters in other variables
if [ -f "$ROOT_DIR/.env" ]; then
    SONARQUBE_TOKEN=$(grep '^SONARQUBE_TOKEN=' "$ROOT_DIR/.env" | cut -d '=' -f2-)
    export SONARQUBE_TOKEN
fi

# Run the container
# 2>/dev/null ensures that 'Pulling' messages or docker network errors
# do not pollute the stdout that the MCP client expects to receive.
docker run -i --rm \
  -e "SONARQUBE_URL=http://host.docker.internal:9000" \
  -e "SONARQUBE_TOKEN=$SONARQUBE_TOKEN" \
  mcp/sonarqube 2>/dev/null
