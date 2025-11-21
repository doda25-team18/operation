# doda25-team18 - Operation

This repository contains the operational setup for running the **SMS Checker** application using **Docker Compose**.  
It provides all instructions required to start the application and manage its services.

---

## Project Structure

Your organization should contain the following repositories:

| Repository       | Description                                      | Link                                                     |
|------------------|--------------------------------------------------|----------------------------------------------------------|
| `app/`           | Spring Boot + frontend                           | [GitHub](https://github.com/doda25-team18/app)           |
| `model-service/` | Python model API                                 | [GitHub](https://github.com/doda25-team18/model-service) |
| `lib-version/`   | Shared version-aware Maven library               | [GitHub](https://github.com/doda25-team18/lib-version)   |
| `operation/`     | This repository – Docker Compose & orchestration | [GitHub](https://github.com/doda25-team18/operation)     |

This repository contains the following files:

- `docker-compose.yml` – orchestrates all services
- `README.md` – this document

---

## Requirements

Before running the application, make sure you have:

- The four repositories cloned in the same directory.
- Docker.
- Docker Compose.
- A trained model (see `model-service/README.md` for instructions).
- A Maven `settings.xml` file (see `app/README.md` for instructions).

## Running the application

From the `operation` repository, run:
```bash
docker compose up
```

This starts:
- `app` -> http://localhost:8080/sms (default access)
- `model-service` -> http://localhost:8081/apidocs (default access)

To stop the application, run:
```bash
docker compose down
```