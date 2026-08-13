# Project bootstrap template

## Prerequisites

- Docker installed
- On Windows: use Docker with WSL2

---

# Container Setup

To get the docker containers up and running, execute the following commands from the project root:

```bash
make build
make start
```

> [!TIP]
> **Network Issues?**
> If you encounter an error stating the `proxy` network is not available, you can create it manually:
>
> ```bash
> docker network create proxy
> ```

---

# Access URLs
* Frontend: http://localhost:59998/

---

# Most Used Make Commands
* `make shell-specific CONTAINER=<container>`: Open the shell of a specific container

* `make build`: Build all docker containers (To use on a single container: `make build-specific CONTAINER=<service>`)
* `make start`: Start all docker containers (To use on a single container: `make start-specific CONTAINER=<service>`)
* `make restart`: Restart all docker containers (To use on a single container: `make restart-specific CONTAINER=<service>`)
* `make stop`: Stop all docker containers (To use on a single container: `make stop-specific CONTAINER=<service>`)
* `make rebuild`: Stop, Build and Start all docker containers

* `make logs`: Read the logs from docker compose (the entire stack), and follow them (like tail -f)  (To use on a single container: `make logs-specific CONTAINER=<service>`)

More commands can be seen within `MAKEFILE`

---

# Nice To Know:
## Different docker-compose files?

* `docker-compose.prod.yml` This is the prod file, with compiled code and just the needed volumes.
  It is stored within the repository as a backup and is not needed for development.

## Continuous Deployment
Whenever code is commited (pushed or merged) into the `main` branch, it will trigger a package-build within GitHub.
