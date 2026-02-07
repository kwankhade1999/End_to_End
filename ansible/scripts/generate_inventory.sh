#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TF_DIR="$PROJECT_ROOT/terraform/environments/dev"
INV_FILE="$PROJECT_ROOT/ansible/inventories/dev/hosts.ini"

cd "$TF_DIR"

get_tf_output() {
  terraform output -raw "$1" 2>/dev/null || true
}

MINIKUBE_IP=$(get_tf_output minikube_public_ip)
SONAR_IP=$(get_tf_output sonarqube_public_ip)
ARGO_IP=$(get_tf_output argocd_public_ip)

# Start clean
> "$INV_FILE"

declare -a GROUPS=()

# Minikube
if [[ -n "$MINIKUBE_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[minikube]
minikube-dev ansible_host=${MINIKUBE_IP}

EOF
GROUPS+=("minikube")
fi

# SonarQube
if [[ -n "$SONAR_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[sonarqube]
sonarqube-dev ansible_host=${SONAR_IP}

EOF
GROUPS+=("sonarqube")
fi

# ArgoCD
if [[ -n "$ARGO_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[argocd]
argocd-dev ansible_host=${ARGO_IP}

EOF
GROUPS+=("argocd")
fi

# Parent group (ONLY valid group names)
if [[ ${#GROUPS[@]} -gt 0 ]]; then
  echo "[devops_tools:children]" >> "$INV_FILE"
  for g in "${GROUPS[@]}"; do
    echo "$g" >> "$INV_FILE"
  done
fi

echo "✅ Ansible inventory generated at $INV_FILE"
