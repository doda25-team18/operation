# doda25-team18 - Operation

This repository contains the operational setup for running the **SMS Checker** application using Docker Compose.  
This README contains all the instructions needed to run the final application.

## Project Structure

Your organization should contain the following repositories:

- `app/` (Spring Boot + frontend)  
  https://github.com/doda25-team18/app

- `model-service/` (Python model API)  
  https://github.com/doda25-team18/model-service

- `lib-version/` (shared version-aware Maven library)  
  https://github.com/doda25-team18/lib-version

- `operation/` (this repo – Docker Compose, orchestration)  
  https://github.com/doda25-team18/operation

This repository ("operation") contains the following files:

- `docker-compose.yml`
- `README.md`

## Requirements

Before running the application, make sure you have:

- The four repositories cloned in one file.
- Docker.
- Docker Compose.
- Trained the model. To do this, you can find the instructions in `model-service/README.md`.
- **!For now!** Make sure to comment out the "lib-version" dependency from `app/pom.xml`:

```
<dependency>
    <groupId>doda25-team18</groupId>
    <artifactId>lib-version</artifactId>
    <version>1.0.0</version>
    <scope>compile</scope>
</dependency>
```

Also comment out all mentions of "VersionUtil" from `app/src/main/java/frontend/ctrl/FrontendController.java`:

```
import doda25.team18.VersionUtil;
```
```
m.addAttribute("libVersion", VersionUtil.getVersion());
```

This will be fixed once exercises F2 is done as well.

## Running the application

First, make sure you are in the "operation" folder.

```
$ cd operation
```

Then do:

```
docker compose up
```

This starts:
- `app` -> http://localhost:8080 (default access)
- `model-service` -> http://localhost:8081 (default access)

To stop the application, do:

```
docker compose down
```