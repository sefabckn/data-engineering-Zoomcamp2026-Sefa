# Workflow Orchestration — Kestra + Examples

## Architecture (visual)

![Workflow diagram](pics/workflow.png)

<!-- Fallback: simple ASCII overview -->
```
User -> Kestra UI/API -> Kestra Server
Kestra Server -> Postgres (kestra_postgres)
Kestra Server -> /app/flows (mounted from ./flows)
Kestra Server -> Docker socket (/var/run/docker.sock) for container tasks
```

This folder contains a self-contained environment to run Kestra (an open-source orchestration and workflow engine) locally using Docker Compose, along with example flows used in the course/module. The README below explains how to run, develop, and troubleshoot the setup, and contains tips for Windows users.

**Quick Links**
- **Compose file:** [02-Workflow-Orchestration/docker-compose.yml](02-Workflow-Orchestration/docker-compose.yml)
- **Flows directory:** [02-Workflow-Orchestration/flows](02-Workflow-Orchestration/flows)

---

## Contents

- **docker-compose.yml** — Docker Compose definition that starts Kestra and supporting services (Postgres, optional pgAdmin).
- **flows/** — Directory containing example flows (YAML files). Kestra watches this directory and loads any `*.yaml` flow definitions.
- **README.md** — This file.

## Objectives

- Provide a reproducible local Kestra development environment.
- Ship a curated set of example flows used in the module.
- Document how to add, test, and debug flows locally.

## Prerequisites

- Docker Desktop (Windows): https://www.docker.com/get-started
- Docker Compose (included with modern Docker Desktop)
- 4+ GB free RAM recommended for local Kestra + Postgres

If you're on Windows WSL2, prefer running Docker from WSL2 or ensure file sharing is enabled for the project directory.

## Running the stack

From this folder (`02-Workflow-Orchestration`) run:

```bash
docker compose up -d
```

This will start:

- `kestra_postgres` — Postgres used as Kestra's repository
- `kestra` — Kestra server (web UI + API)
- optional helper services like `pgadmin` if enabled in `docker-compose.yml`

Check status:

```bash
docker compose ps
```

View Kestra logs (helpful if flows don't appear):

```bash
docker compose logs -f kestra
```

Access the UI at: http://localhost:8080

Default credentials (as configured in the compose file):

- Username: `admin@kestra.io`
- Password: `Admin1234`

Note: Kestra may auto-login if a session cookie exists in your browser.

## Where to put your flows

Place flow definitions as YAML files inside the `flows/` directory. Example files already included:

- `01_Hello_World.yaml` — minimal example
- `02_python.yaml` — shows a Python task
- `04_postgres_taxi.yaml` and others — course-specific examples

Important: Kestra expects flow files (YAML). Subdirectories are ignored by the default watcher unless you explicitly mount and configure them. If you add a folder like `03_getting_started_with_Pipelines` with files inside, move `.yaml` files up to `flows/` or add a matching mount + watcher configuration.

## How the docker-compose file maps flows

- The compose file mounts the repository `./flows` into the container at `/app/flows`.
- Kestra's `micronaut.io.watch.paths` is configured to watch `/app/flows` so new files are picked up automatically.

If you prefer another path, update `docker-compose.yml` and the `micronaut.io.watch.paths` entry so they match.

## Adding a new flow (example)

1. Create a YAML file in `flows/`, e.g. `my_flow.yaml`.
2. The file must declare `id` and `namespace` and follow Kestra flow schema. Example minimal flow:

```yaml
id: hello_world
namespace: local
tasks:
	- id: echo
		type: io.kestra.core.tasks.debugs.Echo
		format: "Hello from Kestra"
```

3. After saving, visit the Kestra UI — the flow should appear under the `local` namespace.

## Developing flows (hot-reload)

- The Compose setup includes file watching, so editing YAML files on your host should auto-refresh them in Kestra.
- If it doesn't appear, try refreshing the UI or restart the `kestra` service:

```bash
docker compose restart kestra
```

## Troubleshooting

- Flows not visible:
	- Confirm your files are plain `.yaml` (not `.yml` vs `.yaml` should both work, but keep consistent).
	- Make sure the container mount exists: run `docker compose exec kestra ls -la /app/flows` to verify.
	- Check Kestra logs: `docker compose logs kestra` for any parsing errors.

- Watcher not detecting changes:
	- On Windows, Docker file sharing / permissions or antivirus may interfere. Use WSL2 or ensure Docker Desktop has access to the project path.
	- If you used absolute Windows paths previously, prefer relative mounts (`./flows`) to avoid cross-OS mismatch.

- Database / migration issues:
	- If Kestra cannot start due to Postgres errors, check `kestra_postgres` logs: `docker compose logs kestra_postgres` and ensure the `kestra` service depends on the DB container.

## Useful commands

```bash
# show running containers for this compose project
docker compose ps

# follow Kestra logs
docker compose logs -f kestra

# execute a shell inside the Kestra container (for inspection)
docker compose exec kestra /bin/sh

# list flows inside the container
docker compose exec kestra ls -la /app/flows
```

## Tips & gotchas (Windows)

- Avoid mounting via absolute Windows paths like `/C/Users/...` inside Compose; prefer relative `./flows` which maps reliably across platforms.
- If you use WSL2, run Docker from the WSL shell where file ownership and inotify work more naturally.
- If you see YAML parsing errors in logs, open the offending YAML and check indentation and types (YAML is whitespace-sensitive).

## Extending the setup

- Add service accounts, secret management or cloud object storage by editing the Kestra configuration block in `docker-compose.yml`.
- For production, run Kestra behind a reverse proxy and use a managed Postgres or RDS instance instead of a local container.

## Example flows included

See the `flows/` directory for course-provided examples. These include simple demos and more advanced tasks that connect to Postgres and GCP (placeholders may require credentials).

## Contributing

- Add new flows as `.yaml` files in `flows/`.
- Keep flow definitions readable and documented with comments when necessary.

## License & Attribution

This folder contains course material. Check the repository root for the project license and attribution.

---
