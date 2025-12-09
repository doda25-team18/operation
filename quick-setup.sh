#!/bin/bash

# Quick Setup Script voor Istio Traffic Management
# Dit script voert alle installatie stappen uit

set -e  # Stop bij errors

echo "======================================"
echo "Istio Traffic Management Quick Setup"
echo "======================================"
echo ""

# Kleuren
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}[1/7]${NC} Checking Minikube..."
if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube with recommended resources..."
    minikube start --memory=4096 --cpus=4 --driver=docker
else
    echo -e "${GREEN}✓${NC} Minikube already running"
fi

echo ""
echo -e "${YELLOW}[2/7]${NC} Checking Istio installation..."
if ! kubectl get namespace istio-system &> /dev/null; then
    echo "Istio not found. Please install manually:"
    echo "  1. Download: curl -L https://istio.io/downloadIstio | sh -"
    echo "  2. cd istio-1.20.0"
    echo "  3. export PATH=\$PWD/bin:\$PATH"
    echo "  4. istioctl install -y"
    echo ""
    echo "Then run this script again."
    exit 1
else
    echo -e "${GREEN}✓${NC} Istio is installed"
fi

echo ""
echo -e "${YELLOW}[3/7]${NC} Checking IngressGateway..."
if ! kubectl get pods -n istio-system -l istio=ingressgateway --no-headers 2>/dev/null | grep -q "Running"; then
    echo "IngressGateway not found or not running."
    echo "Make sure you installed Istio with default profile: istioctl install -y"
    exit 1
else
    echo -e "${GREEN}✓${NC} IngressGateway is running"
fi

echo ""
echo -e "${YELLOW}[4/7]${NC} Labeling namespace for Istio injection..."
if kubectl get namespace default -o jsonpath='{.metadata.labels.istio-injection}' | grep -q "enabled"; then
    echo -e "${GREEN}✓${NC} Namespace already labeled"
else
    kubectl label namespace default istio-injection=enabled
    echo -e "${GREEN}✓${NC} Namespace labeled"
fi

echo ""
echo -e "${YELLOW}[5/7]${NC} Updating Helm dependencies..."
cd helm
helm dependency update
echo -e "${GREEN}✓${NC} Dependencies updated"

echo ""
echo -e "${YELLOW}[6/7]${NC} Installing/Upgrading Helm chart..."
helm upgrade --install team18-a4 . \
  --set istio.enabled=true \
  --set istio.gatewayName=ingressgateway \
  --set istio.trafficSplit.oldVersion=90 \
  --set istio.trafficSplit.newVersion=10

echo -e "${GREEN}✓${NC} Helm chart installed"

echo ""
echo -e "${YELLOW}[7/7]${NC} Waiting for pods to be ready..."
echo "Waiting for app pods..."
kubectl wait --for=condition=ready pod -l app=app --timeout=120s || true
echo "Waiting for model-service pods..."
kubectl wait --for=condition=ready pod -l app=model-service --timeout=120s || true

echo ""
echo "======================================"
echo -e "${GREEN}Setup Complete!${NC}"
echo "======================================"
echo ""
echo "Installed resources:"
kubectl get gateway
kubectl get virtualservices
kubectl get destinationrules
echo ""
kubectl get pods
echo ""
echo "Next steps:"
echo "  1. In a separate terminal, run: minikube tunnel"
echo "  2. Test the setup: ./test-istio-setup.sh"
echo "  3. Access the app: curl -H \"Host: stable.team18.nl\" http://localhost/"
echo ""
