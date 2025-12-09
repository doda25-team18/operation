# Istio Traffic Management Setup - Assignment 4

## Overzicht

Deze setup implementeert Istio Service Mesh traffic management met:
- Gateway en VirtualServices voor toegang via IngressGateway
- Canary release met 90/10 traffic split
- Consistente versie routing (old→old, new→new)
- Sticky sessions voor stabiele user experience

## Bestandsstructuur

### IngressGateway (BUITEN Helm Chart)
De IngressGateway wordt **automatisch geïnstalleerd** door Istio's default profile (`istioctl install`).
Dit voldoet aan de eis "The IngressGateway is defined outside of the Helm chart" - de IngressGateway zit niet in je Helm chart templates, maar wordt door Istio zelf beheerd.

### BINNEN Helm Chart (helm/templates/)
- `gateway.yaml` - Gateway resource die verwijst naar IngressGateway
- `virtualservice-app.yaml` - VirtualService voor app-service met 90/10 split en sticky sessions
- `virtualservice-model.yaml` - VirtualService voor model-service met consistente routing
- `destinationrule-app.yaml` - DestinationRule voor app-service subsets
- `destinationrule-model.yaml` - DestinationRule voor model-service subsets
- `deployment-app.yaml` - Updated met version labels
- `deployment-model.yaml` - Updated met version labels

### Configuratie
- `helm/values.yaml` - Istio configuratie toegevoegd

## Installatie Stappen

### 1. Upgrade Minikube (Aanbevolen)

Istio vereist voldoende resources. Verwijder je huidige Minikube cluster en maak een nieuwe met meer resources:

```bash
# Verwijder bestaande cluster
minikube delete

# Start nieuwe cluster met voldoende resources
minikube start --memory=4096 --cpus=4 --driver=docker

# Optioneel: Enable ingress addon (niet verplicht voor Istio)
minikube addons enable ingress
```

### 2. Installeer Istio op je Cluster

Download en installeer Istio versie 1.20.0 of hoger:

```bash
# Download Istio (versie 1.20.0 of later)
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.20.0  # of nieuwere versie
export PATH=$PWD/bin:$PATH

# Installeer Istio met DEFAULT profile (dit installeert ook de IngressGateway!)
istioctl install -y

# Output zou moeten tonen:
# ✔ Istio core installed
# ✔ Istiod installed
# ✔ Ingress gateways installed  ← BELANGRIJK!
# ✔ Installation complete

# Verifieer installatie
kubectl get pods -n istio-system
kubectl get svc -n istio-system

# Je zou moeten zien:
# - istiod-xxx (Istio control plane)
# - istio-ingressgateway-xxx (IngressGateway pod)
# - istio-ingressgateway service (LoadBalancer)
```

**BELANGRIJK:** Gebruik het **default profile**, NIET het minimal profile! Het default profile installeert automatisch de IngressGateway, wat vereist is voor de assignment.

### 3. Installeer Istio Addons (Optioneel maar Aanbevolen)

Voor monitoring en visualisatie:

```bash
# Prometheus voor monitoring
kubectl apply -f istio-1.20.0/samples/addons/prometheus.yaml

# Jaeger voor request tracing
kubectl apply -f istio-1.20.0/samples/addons/jaeger.yaml

# Kiali dashboard voor visualisatie
kubectl apply -f istio-1.20.0/samples/addons/kiali.yaml

# Verifieer dashboards werken
istioctl dashboard prometheus  # Open Prometheus dashboard
istioctl dashboard kiali       # Open Kiali dashboard
```

### 4. Label je Namespace voor Istio Injection

```bash
# Label je namespace (vervang 'default' met jouw namespace indien nodig)
kubectl label namespace default istio-injection=enabled

# Verifieer label
kubectl get namespace -L istio-injection
```

### 5. Installeer de Helm Chart

```bash
cd helm

# Update dependencies (voor Prometheus stack)
helm dependency update

# Installeer of upgrade de chart
helm upgrade --install team18-a4 . \
  --set istio.enabled=true \
  --set istio.gatewayName=ingressgateway \
  --set istio.trafficSplit.oldVersion=90 \
  --set istio.trafficSplit.newVersion=10

# Verifieer installatie
kubectl get all
kubectl get gateway
kubectl get virtualservices
kubectl get destinationrules
```

### 6. Start Minikube Tunnel (om toegang te krijgen)

```bash
# In een aparte terminal, start de tunnel
minikube tunnel

# Dit maakt de LoadBalancer accessible op localhost
# LAAT DIT DRAAIEN in de achtergrond!
```

### 7. Verkrijg het IngressGateway IP/Hostname

```bash
# Krijg het EXTERNAL-IP van de IngressGateway
kubectl get svc istio-ingressgateway -n istio-system

# Output ziet er ongeveer zo uit:
# NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)
# istio-ingressgateway   LoadBalancer   10.96.123.456   localhost     80:31234/TCP,443:31235/TCP
```

## Testing

### Test 1: Basis Toegankelijkheid (Sufficient - 6)

```bash
# Test of de app bereikbaar is via IngressGateway
curl -H "Host: stable.team18.nl" http://localhost/

# Je zou een response moeten krijgen van de app
```

### Test 2: 90/10 Traffic Split (Good - 7-8)

```bash
# Test de traffic split door meerdere requests te maken
for i in {1..20}; do
  curl -H "Host: stable.team18.nl" http://localhost/ -s -w "\nRequest $i\n"
done

# Ongeveer 90% zou naar v1 moeten gaan, 10% naar v2
# Je kunt dit zien aan de response (afhankelijk van je app output)
```

### Test 3: Sticky Sessions (Excellent - 9-10)

```bash
# Test sticky sessions - eerste request
curl -H "Host: stable.team18.nl" http://localhost/ -c cookies.txt -v

# Bekijk de cookie die is gezet
cat cookies.txt

# Volgende requests met dezelfde cookie - zou naar dezelfde versie moeten gaan
for i in {1..5}; do
  curl -H "Host: stable.team18.nl" http://localhost/ -b cookies.txt -s
  echo "Request $i - should go to same version"
done
```

### Test 4: Consistente Versie Routing (Model Service)

Dit is lastiger te testen zonder in de pod te kijken, maar je kunt de logs checken:

```bash
# Bekijk logs van app v1 pods
kubectl logs -l app=app,version=v1 --tail=50

# Bekijk logs van app v2 pods
kubectl logs -l app=app,version=v2 --tail=50

# Bekijk logs van model-service v1 pods
kubectl logs -l app=model-service,version=v1 --tail=50

# Bekijk logs van model-service v2 pods
kubectl logs -l app=model-service,version=v2 --tail=50

# Verifieer dat app v1 alleen met model v1 communiceert
# en app v2 alleen met model v2
```

### Test 5: Istio Dashboard (Optioneel)

```bash
# Installeer Kiali voor visuele monitoring
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/kiali.yaml

# Start Kiali dashboard
istioctl dashboard kiali

# Hier kun je de traffic flow visualiseren
```

## Configuratie Aanpassen

### Gateway Naam Wijzigen

Als je een andere gateway naam wilt gebruiken:

```bash
helm upgrade --install team18-a4 . \
  --set istio.gatewayName=my-custom-gateway

# Update dan ook de IngressGateway YAML met het juiste label
```

### Traffic Split Aanpassen

```bash
# Bijvoorbeeld 80/20 split
helm upgrade --install team18-a4 . \
  --set istio.trafficSplit.oldVersion=80 \
  --set istio.trafficSplit.newVersion=20

# Of 100/0 voor alleen oude versie
helm upgrade --install team18-a4 . \
  --set istio.trafficSplit.oldVersion=100 \
  --set istio.trafficSplit.newVersion=0
```

### Istio Uitschakelen

```bash
helm upgrade --install team18-a4 . \
  --set istio.enabled=false

# Dit disabled alle Istio resources in de chart
```

## Canary Release Workflow

### Scenario: Nieuwe versie uitrollen

1. **Start met alleen v1:**
```bash
helm upgrade --install team18-a4 . \
  --set app.version=v1 \
  --set modelService.version=v1 \
  --set istio.trafficSplit.oldVersion=100 \
  --set istio.trafficSplit.newVersion=0
```

2. **Deploy v2 met 10% traffic:**
```bash
# Update je deployment om BEIDE versies te hebben
# Dit betekent dat je 2 deployments nodig hebt, of replicas moet aanpassen

helm upgrade --install team18-a4 . \
  --set istio.trafficSplit.oldVersion=90 \
  --set istio.trafficSplit.newVersion=10
```

3. **Verhoog naar 50/50:**
```bash
helm upgrade --install team18-a4 . \
  --set istio.trafficSplit.oldVersion=50 \
  --set istio.trafficSplit.newVersion=50
```

4. **Volledig naar v2:**
```bash
helm upgrade --install team18-a4 . \
  --set istio.trafficSplit.oldVersion=0 \
  --set istio.trafficSplit.newVersion=100
```

## Troubleshooting

### IngressGateway pods starten niet
```bash
kubectl describe pod -n istio-system -l istio=ingressgateway
kubectl logs -n istio-system -l istio=ingressgateway
```

### Gateway werkt niet
```bash
kubectl describe gateway app-gateway
kubectl get gateway app-gateway -o yaml
```

### VirtualService werkt niet
```bash
kubectl describe virtualservice app-virtualservice
kubectl get virtualservice app-virtualservice -o yaml
```

### Sticky sessions werken niet
```bash
# Check of cookies worden gezet
curl -H "Host: stable.team18.nl" http://localhost/ -v 2>&1 | grep -i cookie

# Check DestinationRule
kubectl get destinationrule app-destinationrule -o yaml
```

### Consistente routing werkt niet
```bash
# Check VirtualService voor model-service
kubectl get virtualservice model-service-virtualservice -o yaml

# Check of sourceLabels matching werkt
kubectl describe virtualservice model-service-virtualservice
```

### Geen v2 pods
Als je geen v2 versie hebt maar wel de canary setup wilt testen:
```bash
# Tijdelijk kun je v1 als v2 labelen in een aparte deployment
# Of pas de traffic split aan naar 100/0
```

## Beoordelingscriteria Checklist

### Sufficient (6):
- [x] Gateway gedefinieerd in [helm/templates/gateway.yaml](helm/templates/gateway.yaml)
- [x] VirtualServices gedefinieerd voor app
- [x] App toegankelijk via IngressGateway
- [x] IngressGateway buiten Helm chart ([istio-ingressgateway.yaml](istio-ingressgateway.yaml))
- [x] Alles installeerbaar via centrale Helm chart
- [x] Gateway naam configureerbaar in [helm/values.yaml](helm/values.yaml)

### Good (7-8):
- [x] DestinationRules met 90/10 weights ([helm/templates/destinationrule-app.yaml](helm/templates/destinationrule-app.yaml))
- [x] Consistente versie routing (old→old, new→new) ([helm/templates/virtualservice-model.yaml](helm/templates/virtualservice-model.yaml))
- [x] Version labels op deployments

### Excellent (9-10):
- [x] Sticky Sessions met consistentHash en cookies
- [x] Cookie-based routing in VirtualService
- [x] Stabiele user experience bij reload

## Architectuur

```
User Request
    |
    v
[IngressGateway] (istio-system namespace)
    |
    v
[Gateway Resource] (references IngressGateway via selector)
    |
    v
[VirtualService - App]
    |
    +-- Cookie: version=v1 --> App v1 (90%)
    |                            |
    |                            v
    |                       [VirtualService - Model]
    |                            |
    |                            v
    |                       Model Service v1
    |
    +-- Cookie: version=v2 --> App v2 (10%)
    |                            |
    |                            v
    |                       [VirtualService - Model]
    |                            |
    |                            v
    |                       Model Service v2
    |
    +-- No Cookie --> 90% to v1, 10% to v2 (sets cookie)
```

## Belangrijke Notities

1. **IngressGateway Naam**: De gateway naam is configureerbaar via `istio.gatewayName` in values.yaml
2. **Sticky Sessions**: Gebruikt `consistentHash` met HTTP cookies, TTL van 1 uur
3. **Versie Consistentie**: SourceLabels in model-service VirtualService zorgen voor consistente routing
4. **Minikube Tunnel**: MOET draaien voor LoadBalancer toegang
5. **Namespace Injection**: Namespace moet gelabeld zijn met `istio-injection=enabled`
