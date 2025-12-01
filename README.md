# doda25-team18 - Operation

This repository contains the operational setup for running the **SMS Checker** application using **Docker Compose**.  
It provides all instructions required to start the application and manage its services.

---

## Project Structure

Your organization should contain the following repositories:

| Repository       | Description                                      | Link                                                             |
|------------------|--------------------------------------------------|------------------------------------------------------------------|
| `app/`           | Spring Boot + frontend                           | [GitHub](https://github.com/doda25-team18/app/tree/a1)           |
| `model-service/` | Python model API                                 | [GitHub](https://github.com/doda25-team18/model-service/tree/a1) |
| `lib-version/`   | Shared version-aware Maven library               | [GitHub](https://github.com/doda25-team18/lib-version/tree/a1)   |
| `operation/`     | This repository – Docker Compose & orchestration | [GitHub](https://github.com/doda25-team18/operation/tree/a1)     |

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

---

## Kubernetes Deployment

This project uses a Helm chart to deploy the application stack to Kubernetes.

### Installation

To install the application, run the following command from the `operation` directory. You can set the `ingress.host` to any hostname you prefer.

```bash
helm install test-a3 ./helm --set ingress.host=test.local
```

### Accessing on Localhost (Minikube on macOS/Windows)

Due to the network limitations of Minikube when using the Docker driver on macOS and Windows, the Ingress IP is not directly routable from the host machine. To access the application locally, follow these steps after installing the Helm chart:

1.  **Update your hosts file:**
    Ensure your `/etc/hosts` file (or `C:\Windows\System32\drivers\etc\hosts` on Windows) contains an entry for your chosen hostname pointing to `127.0.0.1`.
    127.0.0.1 test.local
   

2.  **Forward the Ingress port:**
    Open a **separate terminal window** and run the following command. This will forward your local port 80 to the Ingress controller inside the Minikube cluster. This requires `sudo` because it uses a privileged port.

    sudo kubectl port-forward --namespace ingress-nginx service/ingress-nginx-controller 80:80
    
    Keep this terminal window running.

3.  **Access the application:**
    You can now access the application in your browser at the hostname you configured, without any port number:
    
    [http://test.local](http://test.local)

This method allows you to test the full Ingress setup locally. On a cloud-based Kubernetes cluster, the `LoadBalancer` service would get a real external IP, and this port-forwarding step would not be necessary.
