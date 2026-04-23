#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

if [ -f "$ROOT_DIR/.env" ]; then
    SONARQUBE_TOKEN=$(grep '^SONARQUBE_TOKEN=' "$ROOT_DIR/.env" | cut -d '=' -f2-)
fi

# 2>/dev/null prevents Docker pull/network messages from polluting MCP stdout.
# Uses the internal dev-network so the MCP container reaches SonarQube
# by its service hostname without needing host.docker.internal.
docker run -i --rm \
  --network dev-network \
  -e "SONARQUBE_URL=http://sonarqube:9000" \
  -e "SONARQUBE_TOKEN=$SONARQUBE_TOKEN" \
  mcp/sonarqube 2>/dev/null
