# Agent Guide: Software Development Tools

This repository is designed as a centralized, containerized hub for software development tools. It provides a standardized environment for local development using Docker, with a heavy focus on automation and security.

## Core Mission
To provide a ready-to-use development infrastructure (Databases, Analysis Tools, etc.) that can be quickly initialized with secure, randomized credentials and project-specific skills.

## Technical Architecture

### 1. Orchestration
- **Docker Compose**: Orchestrates PostgreSQL 18.3, pgAdmin 4, and SonarQube Community Build.
- **Networking**: All services reside in a bridge network named `dev-network`.
- **Persistence**: Data is persisted through named Docker volumes (`postgres_data`, `sonarqube_data`, etc.).

### 2. Automation Scripts (`/scripts`)
- **`setup-env.sh`**: The entry point. Generates randomized usernames (min 10 chars) and secure passwords (20-24 chars). It populates the `.env` file from `.env.example`.
- **`init-db.sh`**: Executed by the PostgreSQL container during the first boot. It creates the dedicated database and user for SonarQube.
- **`configure-sonar.sh`**: A post-deployment script. It waits for the SonarQube API to be ready and automatically changes the default `admin/admin` credentials to the secure password defined in `.env`.
- **install-skills.sh**: Manages project-specific skills. It uses an internal array and `npx skills add` to install tools into ignored local directories.

### 3. MCP Configuration (Project-Specific)
The repository includes templates for local (workspace) Model Context Protocol configurations. These files allow tools to detect project-specific servers automatically:
- **`.mcp.json.example`**: For **Claude Code** (detected in project root).
- **`.copilot/mcp-config.json.example`**: For **GitHub Copilot CLI**.
- **`.gemini/settings.json.example`**: For **Gemini CLI**.
- **`opencode.json.example`**: For **Open Code**.

To use them, copy the `.example` file to its corresponding name (e.g., `cp .mcp.json.example .mcp.json`). Actual `.json` files are ignored by Git.

### 4. Conventions & Constraints


- **Language**: All code, documentation, and commits must be in **English**.
- **Security**: Never commit `.env` or any file containing actual credentials.
- **Skills/Agents**: Local skills must be installed within the project scope, not globally.
- **Ignored Paths**: Be aware that `.agents/`, `.skills/`, `.claude/`, and `.env` are ignored by git.

## Workflow for New Agents
1. Verify prerequisites (Docker, npx).
2. Run `./scripts/setup-env.sh` to prepare the environment.
3. Run `docker compose up -d` to launch services.
4. Run `./scripts/configure-sonar.sh` to finalize SonarQube security.
5. Use `./scripts/install-skills.sh` to add any required AI capabilities.

## Future Extensions
When adding new tools:
1. Update `docker-compose.yml`.
2. Add necessary variables to `.env.example`.
3. Update `setup-env.sh` if new credentials need to be randomized.
4. Document the tool in the main `README.md`.
