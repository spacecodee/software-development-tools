# Software Development Tools (Docker)

This project centralizes essential software development tools using Docker.

## Included Tools
- **PostgreSQL 18.3**: Primary database.
- **pgAdmin 4**: Web interface for managing PostgreSQL.
- **SonarQube Server 2026.2.1**: Code quality and security platform.

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
