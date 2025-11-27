#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="devops-challenge"
SERVICE_NAME="devops-challenge-svc"

echo "1) Find pod name..."
POD=$(kubectl get pods -n "${NAMESPACE}" -l app=devops-challenge -o jsonpath='{.items[0].metadata.name}')
echo "Pod: ${POD}"

echo
echo "2) UID of the user inside the container (should NOT be 0):"
kubectl exec -n "${NAMESPACE}" "${POD}" -- id -u

echo
echo "3) Show processes and port binding inside the container:"
kubectl exec -n "${NAMESPACE}" "${POD}" -- sh -c "ss -tulnp || netstat -tulnp || lsof -i -P -n | head -n 20" || true

echo
echo "4) Port-forward service to localhost:8080 and curl root path:"
kubectl port-forward -n "${NAMESPACE}" service/${SERVICE_NAME} 8080:80 >/tmp/portforward.log 2>&1 &
PF_PID=$!
sleep 2

echo "Curling http://localhost:8080"
HTTP=$(curl -s -o /tmp/response.json -w "%{http_code}" http://localhost:8080/)
echo "HTTP status: ${HTTP}"
echo "Response body:"
cat /tmp/response.json
echo

# validate exact JSON content
EXPECTED='{"message":"Hello, Candidate","version":"1.0.0"}'
ACTUAL=$(jq -c . /tmp/response.json)
if [ "${ACTUAL}" = "${EXPECTED}" ]; then
  echo "✅ JSON exactly matches expected payload."
else
  echo "❌ JSON does NOT exactly match expected payload. Actual: ${ACTUAL}"
fi

echo "Cleaning up port-forward (killing PID ${PF_PID})"
kill "${PF_PID}" || true
