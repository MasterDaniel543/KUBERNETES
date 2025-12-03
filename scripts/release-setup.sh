#!/usr/bin/env bash
set -euo pipefail
NAMESPACE=${1:-release}
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n "$NAMESPACE" -f k8s/service.yaml
kubectl apply -n "$NAMESPACE" -f k8s/deploy.yaml
kubectl set image deployment/app app="$REGISTRY/$IMAGE_NAME:$IMAGE_TAG" -n "$NAMESPACE"
kubectl apply -n "$NAMESPACE" -f k8s/ingress.yaml
kubectl rollout status deployment/app -n "$NAMESPACE"
