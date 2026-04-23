#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

if [ -f "$ROOT_DIR/.env" ]; then
    CONTEXT7_API_KEY=$(grep '^CONTEXT7_API_KEY=' "$ROOT_DIR/.env" | cut -d '=' -f2-)
    export CONTEXT7_API_KEY
fi

exec npx -y @upstash/context7-mcp
