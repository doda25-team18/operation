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
helm install test-a3 ./helm --set ingress.host=test.local --set secrets.smtpPassword="your-secure-password"

```

### Accessing on Localhost (Minikube on macOS/Windows)

Due to the network limitations of Minikube when using the Docker driver on macOS and Windows, the Ingress IP is not directly routable from the host machine. To access the application locally, follow these steps after installing the Helm chart:

1.  **Update your hosts file:**
    Ensure your `/etc/hosts` file (or `C:\Windows\System32\drivers\etc\hosts` on Windows) contains an entry for your chosen hostname pointing to `127.0.0.1`.
    127.0.0.1 test.local
   

2.  **Forward the Ingress port:**
    Open a **separate terminal window** and run the following command. This will forward your local port 80 to the Ingress controller inside the Minikube cluster. This requires `sudo` because it uses a privileged port.

    ```bash
    sudo kubectl port-forward --namespace ingress-nginx service/ingress-nginx-controller 80:80
    ``` 

    Keep this terminal window running.

4.  **Access the application:**
    You can now access the application in your browser at the hostname you configured, without any port number:
    
    [http://test.local](http://test.local)

This method allows you to test the full Ingress setup locally. On a cloud-based Kubernetes cluster, the `LoadBalancer` service would get a real external IP, and this port-forwarding step would not be necessary.


### Accessing on LocalHost (without using Minikube tunnel, with ingress)

To launch the application locally without using minikube tunnel:

1. **Enable ingress:**
    This can be done by running
   ```bash
    minikube addons enable ingress
   ```

2. **Get ingress ip address**
    By running
   ```bash
       kubectl get ingress
   ```

3. Update your `/etc/hosts` file (`C:\Windows\System32\drivers\etc\hosts` on Windows) by adding ```test.local <ingress ip address>```

4. Open [test.local/sms](http://test.local/sms)

---

## Istio Service Mesh (A4)

This project includes Istio traffic management with:
- Gateway and VirtualServices for IngressGateway routing
- 90/10 canary release traffic split
- Consistent version routing (v1→v1, v2→v2)
- Sticky sessions using consistentHash cookies

### Prerequisites

1. Install Istio (default profile):
   ```bash
   curl -L https://istio.io/downloadIstio | sh -
   cd istio-1.28.1
   export PATH=$PWD/bin:$PATH
   istioctl install -y
   ```

2. Label namespace for Istio injection:
   ```bash
   kubectl label namespace default istio-injection=enabled
   ```

### Installation

Install the Helm chart with Istio enabled:
```bash
helm upgrade --install team18-a4 ./helm \
  --set istio.enabled=true \
  --set istio.gatewayName=ingressgateway \
  --set istio.trafficSplit.oldVersion=90 \
  --set istio.trafficSplit.newVersion=10
```

### Configuration

Istio settings in `helm/values.yaml`:
- `istio.enabled`: Enable/disable Istio resources
- `istio.gatewayName`: IngressGateway name (configurable)
- `istio.trafficSplit.oldVersion`: Percentage to v1 (default: 90)
- `istio.trafficSplit.newVersion`: Percentage to v2 (default: 10)

## 6. Additional Use Case

We implemented global and per-user rate limiting on the Istio Ingress Gateway using the Envoy Global
Rate Limit Service:

- Global limit (/sms/ path): Maximum 10 requests per minute across all users
- Per-user limit (via X-User-ID header): Maximum 5 requests per minute per user

### Testing

1. Global Rate Limit Test: Send more than 10 requests within a minute:

> Note: Use correct hostname! (+ /sms/ is required for global rate limit)

```bash
for i in {1..15}; do
  echo "Request $i"
  curl -I http://stable.team18.nl/sms/ 
  echo ""
done
```

Expected result:

- First 10 requests → 200 OK
- After limit → HTTP 429 Rate Limited

2. Per-User Rate Limit Test: Send repeated requests using the same user ID:

```bash
for i in {1..7}; do
  echo "Request $i - Alice"
  curl -I -H "X-User-ID: alice" http://stable.team18.nl/
  echo ""
done
echo "Request 8 - Bob"
curl -i -H "X-User-ID: bob" http://stable.team18.nl/
```

Expected result:

- First 5 requests → 200 OK
- After limit → HTTP 429 Rate Limited
- Different user -> 200 OK
