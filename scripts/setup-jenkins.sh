#!/bin/bash

set -e

echo "================================="
echo "Installing Jenkins"
echo "================================="

helm repo add jenkins https://charts.jenkins.io || true
helm repo update

helm upgrade --install jenkins \
  jenkins/jenkins \
  --namespace jenkins \
  --create-namespace \
  -f helm/charts/jenkins/values.yaml

echo "Waiting for Jenkins..."

kubectl rollout status \
  statefulset/jenkins \
  -n jenkins \
  --timeout=300s

echo "================================="
echo "Jenkins Admin Password"
echo "================================="

kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- \
  /bin/cat /run/secrets/additional/chart-admin-password && echo

echo "================================="
echo "To access Jenkins UI, run:"
echo "kubectl --namespace jenkins port-forward svc/jenkins 8080:8080"
echo "Then visit http://localhost:8080"
echo "================================="
