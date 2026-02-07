#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TF_DIR="$PROJECT_ROOT/terraform/environments/dev"
INV_FILE="$PROJECT_ROOT/ansible/inventories/dev/hosts.ini"

cd "$TF_DIR"

# Ensure jq exists
command -v jq >/dev/null 2>&1 || {
  echo "❌ jq is required but not installed"
  exit 1
}

TF_OUTPUT_JSON=$(terraform output -json 2>/dev/null || echo "{}")

get_ip() {
  echo "$TF_OUTPUT_JSON" | jq -r ".${1}.value // empty"
}

MINIKUBE_IP=$(get_ip minikube_public_ip)
SONAR_IP=$(get_ip sonarqube_public_ip)
ARGO_IP=$(get_ip argocd_public_ip)

# Start clean
> "$INV_FILE"

declare -a INVENTORY_GROUPS=()

if [[ -n "$MINIKUBE_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[minikube]
minikube-dev ansible_host=${MINIKUBE_IP}

EOF
INVENTORY_GROUPS+=("minikube")
fi

if [[ -n "$SONAR_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[sonarqube]
sonarqube-dev ansible_host=${SONAR_IP}

EOF
INVENTORY_GROUPS+=("sonarqube")
fi

if [[ -n "$ARGO_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[argocd]
argocd-dev ansible_host=${ARGO_IP}

EOF
INVENTORY_GROUPS+=("argocd")
fi

if [[ ${#INVENTORY_GROUPS[@]} -gt 0 ]]; then
  echo "[devops_tools:children]" >> "$INV_FILE"
  for g in "${INVENTORY_GROUPS[@]}"; do
    echo "$g" >> "$INV_FILE"
  done
fi

echo "✅ Ansible inventory generated at $INV_FILE"

