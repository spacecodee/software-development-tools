# Software Development Tools (Docker)

This project centralizes essential software development tools using Docker.

## Included Tools
- **PostgreSQL 18.3**: Primary database.
- **pgAdmin 4**: Web interface for managing PostgreSQL.
- **SonarQube Server 2026.2.1**: Code quality and security platform.
- **Mailpit**: SMTP testing server and web UI for email sandboxing.

## Initial Setup

1. **Generate Credentials**:
   Run the configuration script to generate random usernames and secure passwords in your `.env` file:
   ```bash
   ./scripts/setup-env.sh
   ```

2. **SonarQube Requirement (Host)**:
   SonarQube uses Elasticsearch, which requires the host system's `vm.max_map_count` parameter to be at least `262144`.
   
   On Linux, you can set it temporarily with:
   ```bash
   sudo sysctl -w vm.max_map_count=262144
   ```
   To make it permanent, add `vm.max_map_count=262144` to `/etc/sysctl.conf`.

3. **Start the Services**:
   ```bash
   docker compose up -d
   ```

4. **Configure SonarQube Admin Password**:
   Once the containers are running, you can automatically change the default `admin/admin` password to the secure one defined in `.env`:
   ```bash
   ./scripts/configure-sonar.sh
   ```

## Access
- **pgAdmin**: [http://localhost:5050](http://localhost:5050) (Credentials in `.env`)
- **SonarQube**: [http://localhost:9000](http://localhost:9000) (Default admin: `admin`/`admin`)
- **Mailpit Web UI**: [http://localhost:8025](http://localhost:8025)
- **Mailpit SMTP**: `localhost:1025`
- **Postgres**: `localhost:5432`

## Security
- The `.env` file contains actual credentials and is ignored by git.
- The `.env.example` file contains the required structure.
- The `setup-env.sh` script generates random users (at least 10 characters) and secure passwords (24 characters).

## Skills Management
To install project-specific skills, use the provided script:
```bash
./scripts/install-skills.sh
```
This script uses the official `skills.sh` syntax to add tools directly to the project.

## MCP Servers
This project includes configurations for Model Context Protocol (MCP) servers.

### Context7
Context7 provides up-to-date documentation and code examples for programming libraries.
- **Setup**: Runs via local wrapper script (`./scripts/mcp-context7.sh`) that reads `CONTEXT7_API_KEY` from `.env` and passes it to `npx @upstash/context7-mcp`.
- **Environment Variable**: Ensure `CONTEXT7_API_KEY` is set in your `.env` file (see `.env.example`).
- **Usage**: Referenced in `opencode.json.example`, `.mcp.json.example`, `.gemini/settings.json.example`, and `.copilot/mcp-config.json.example`.

### SonarQube
Allows the agent to interact with SonarQube for code quality and security analysis.
- **Setup**: Runs via local wrapper script (`./scripts/mcp-sonarqube.sh`) that manages Docker execution and token retrieval from `.env`.
- **Usage**: Referenced in `.mcp.json.example` and `.gemini/settings.json`.
