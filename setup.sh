#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="devops-challenge-image:local"
HELM_RELEASE="devops-challenge"
HELM_CHART_PATH="./helm"
NAMESPACE="devops-challenge"

echo "Building Docker image: ${IMAGE_NAME}"
docker build -t "${IMAGE_NAME}" .

# Try to load image into kind or minikube, else rely on local docker in cluster (Docker Desktop)
if command -v kind &>/dev/null && kind get clusters | grep -q . ; then
  echo "Detected kind cluster. Loading image into kind..."
  kind load docker-image "${IMAGE_NAME}"
elif command -v minikube &>/dev/null && minikube status &>/dev/null; then
  echo "Detected minikube. Loading image into minikube..."
  minikube image load "${IMAGE_NAME}"
else
  echo "No kind/minikube detected. Ensure your cluster can pull local docker images (Docker Desktop)."
fi

echo "Initializing Terraform..."
pushd terraform >/dev/null
terraform init -input=false
terraform apply -auto-approve
popd >/dev/null

echo "Installing Helm chart..."
# Update values to use local image
helm upgrade --install "${HELM_RELEASE}" "${HELM_CHART_PATH}" \
  --namespace "${NAMESPACE}" --create-namespace \
  --set image.repository=devops-challenge-image \
  --set image.tag=local

echo "Deployment applied. Showing pods:"
kubectl get pods -n "${NAMESPACE}" -o wide

echo "Done."
