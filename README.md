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

## Provisioning a Kubernetes Cluster (A2)

This repository provisions a complete Kubernetes cluster using **Vagrant**, **VirtualBox**, and *
*Ansible**.

### Provision the Cluster

```bash
vagrant up --provision
```

### Install Cluster Add-ons (MetalLB, Ingress, Dashboard)

```bash
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
```

### Access the VMs

Controller node:

```bash
vagrant ssh ctrl
```

Worker nodes:

```bash
vagrant ssh node-{i} # Replace i with a number
```

### Access the Kubernetes Dashboard

1. Add dashboard domain on the host:

```
192.168.56.90 dashboard.local
```

2. Generate login token on the controller:

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

3. Open in browser:

```
http://dashboard.local
```

Login using the generated token.

---

## Operate and Monitor Kubernetes (A3)

This project uses a Helm chart to deploy the application stack to Kubernetes.

### 1. Prerequisites

Before installing the application, ensure your cluster is ready:

#### Option A: Custom Provisioned Cluster

Ensure you have a provisioned kubernetes cluster (A2) with:

- Nginx Ingress Controller
- MetalLB (LoadBalancer)
- Istio Service Mesh

#### Option B: Minikube

If testing on Minikube, start the cluster and install Istio manually:

```bash
minikube start --addons=ingress
# Install Istio (default profile)
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.28.1 && export PATH=$PWD/bin:$PATH
istioctl install -y
# Enable automatic sidecar injection
kubectl label namespace default istio-injection=enabled
```

### 2. Helm Installation

Run the following command from the `operation` directory (or `/vagrant` if you are logged into the
`ctrl` VM).

You can set the `ingress.host` to any hostname you prefer (e.g., `stable.team18.nl`). This README
uses `stable.team18.nl` for all examples.

```bash
helm upgrade --install team18-final ./helm \
  --set ingress.host=stable.team18.nl \
  --set secrets.smtpPassword="your-secure-password"
```

---

### 3. Accessing the Application

#### On Custom Provisioned Cluster (Vagrant)

Our cluster uses **MetalLB** to provide a consistent LoadBalancer IP.

1. **Verify the Ingress External IP:**
    ```bash
    kubectl get service -n nginx ingresscontroller-ingress-nginx-controller
    ```
   *Note: In our default setup, this IP is fixed at `192.168.56.90`.*

2. **Map the Hostname:**
   Add the following entry to your host machine's `/etc/hosts` file:
   ```text
   192.168.56.90 stable.team18.nl
   ```

3. **Access:** Open [http://stable.team18.nl/sms](http://stable.team18.nl/sms) in your browser.

#### On Minikube

Minikube requires a tunnel to route traffic to the internal Ingress controller on macOS/Windows.

1. **Start the Tunnel:**
   In a **separate terminal window**, run:
   ```bash
   sudo minikube tunnel
   ```

2. **Map the Hostname:**
   Add the following entry to your host machine's `/etc/hosts`:
   ```text
   127.0.0.1 stable.team18.nl
   ```

3. **Access:** Open [http://stable.team18.nl/sms](http://stable.team18.nl/sms).

---

### 4. App Monitoring and Alerting

We have configured Prometheus and AlertManager to alert developers when the traffic is high.

Since these tools are internal to the cluster, you must use `port-forward` to access their UIs.

- **For Vagrant Cluster:** Run these commands **inside the `ctrl` VM** (`vagrant ssh ctrl`).
- **For Minikube:** Run these commands **in your local terminal**.

**Prometheus (Alert Rules):**

```bash
kubectl port-forward --address 0.0.0.0 svc/team18-final-kube-promethe-prometheus 9090:9090
```

Open in browser:
[http://192.168.56.100:9090](http://192.168.56.100:9090) (Vagrant)
or [http://localhost:9090](http://localhost:9090) (Minikube)

**AlertManager (Notification Status):**

```bash
kubectl port-forward --address 0.0.0.0 svc/team18-final-kube-promethe-alertmanager 9093:9093
```

[http://192.168.56.100:9093](http://192.168.56.100:9093) (Vagrant)
or [http://localhost:9093](http://localhost:9093) (Minikube)
**MailPit (Email Inbox):**

```bash
kubectl port-forward --address 0.0.0.0 svc/mailpit 8025:8025
```

[http://192.168.56.100:8025](http://192.168.56.100:8025) (Vagrant)
or [http://localhost:8025](http://localhost:8025) (Minikube)

#### Triggering a Test Alert

Run the following command in your terminal to generate enough traffic to trigger the
`HighPredictionRequestRate` alert (it sends a few predict requests, exceeding the threshold of 2):
Note: If alert is not fired immediately, wait a few seconds.

```bash
for i in {1..5}; do 
  curl -X POST http://stable.team18.nl/sms/ \
    -H "Content-Type: application/json" \
    -d '{"sms": "Test alert trigger", "guess": "spam"}'; 
  sleep 1; 
done
```

### Grafana

To see the Grafana dashboards, first run:

```bash
kubectl port-forward --address 0.0.0.0 svc/team18-final-grafana 3000:80
```

[http://192.168.56.100:3000](http://192.168.56.100:3000) (Vagrant)
or [http://localhost:3000](http://localhost:3000) (Minikube)

The login credentials are:
Username: `admin`
Password: `admin`

When here, go to `Dashboards`, and you should see:
- `decision-dashboard`
- `metrics-dashboard`

If they are not there, you can import the JSON files from `helm/dashboards/`

*Note: To see live data in Grafana, generate traffic using the application
at [http://stable.team18.nl/sms](http://stable.team18.nl/sms).*


---

## Istio Service Mesh (A4)

This project includes Istio traffic management with:
- Gateway and VirtualServices for IngressGateway routing
- 90/10 canary release traffic split
- Consistent version routing (v1→v1, v2→v2)
- Sticky sessions using consistentHash cookies

### Installation

Install the Helm chart with Istio enabled:
```bash
helm upgrade --install team18-final ./helm \
  --set ingress.host=stable.team18.nl \
  --set secrets.smtpPassword="your-secure-password" \
  --set istio.enabled=true \
  --set istio.gatewayName=ingressgateway \
  --set istio.trafficSplit.oldVersion=90 \
  --set istio.trafficSplit.newVersion=10
```

**Important:** In our default setup, Istio features work through the **Istio IngressGateway** at
`192.168.56.92`, not the
Nginx Ingress at `192.168.56.90`. Make sure your `/etc/hosts` points to the correct IP:

```text
192.168.56.92 stable.team18.nl
```

### Configuration

Istio settings in `helm/values.yaml`:
- `istio.enabled`: Enable/disable Istio resources
- `istio.gatewayName`: IngressGateway name (configurable)
- `istio.trafficSplit.oldVersion`: Percentage to v1 (default: 90)
- `istio.trafficSplit.newVersion`: Percentage to v2 (default: 10)

### Additional Use Case

We implemented global and per-user rate limiting on the Istio Ingress Gateway using the Envoy Global
Rate Limit Service:

- Global limit (/sms/ path): Maximum 10 requests per minute across all users
- Per-user limit (via X-User-ID header): Maximum 5 requests per minute per user

#### Testing

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
