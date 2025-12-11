# Deployment Documentation - Team 18

This document describes the structure and the data flow of our final deployment.

## 1. Deployment Structure

Our system consists of a frontend (`app-service`) and backend (`model-service`), which support two versions ('v1' stable, 'v2' canary) for continuous experimentation (TWO VERSIONS NOT YET IMPLEMENTED), and Istio routing components, including `Gateway`, `VirtualService`, and `DestinationRule`, which support the trafic management through our deployment. We also include Prometheus and Grafana in order to monitor specific metrics and create dashboards to compare the two versions (MONITORING NOT YET IMPLEMENTED).

We also implemented rate limiting... (ADDITIONAL USE CASE TBD).

*add figure here with the connections between them*

## 2. Deployment Flow

A typical user request flows through the system as follows:

1. **Client -> Istio Gateway**  
   The user sends an HTTP request.

2. **Istio Gateway -> VirtualService**  
   The `Istio Gateway` receives the request and applies the routing rules defined in `VirtualService`.

3. **VirtualService -> app-service**  
   The `VirtualService` decides whether the request should be routed to `v1` or `v2` of `app-service`, based on its configured 90/10 weights.

4. **app-service -> model-service**  
   The request flows from `app-service` to `model-service`. Sticky session ensures that the user stays on the same version: if the request is sent to `app-service-v1`, then it will be handled by `model-service-v1` and not `model-service-v2`. The same applies for `app-service-v2` as well.

5. **model-service -> app-service -> Client**  
   The `model-service` returns the prediction to the `app-service`, which constructs the HTTP response and sends it back to the client via the same path **(app → VirtualService → IngressGateway → client)**.

*add figure here*

## 3. Dynamic Routing

The decission of dynamic routing is done in `VirtualService`. We have a 90/10 split, which means that 90% of request go to the stable version `v1`, and 10% go to the canary version `v2`. Then, the traffic is directed to subsets defined in the `DestinationRule`.

## 4. Continuous Experimentation

TBD

## 5. Monitoring

TBD

## 6. Additional Use Case

TBD

## 7. External Access

- hostnames: stable.team18.nl
- ports: 80
- paths:
