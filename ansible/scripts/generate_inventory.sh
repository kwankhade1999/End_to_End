#!/bin/bash

set -e

# Get project root directory (robust way)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TF_DIR="$PROJECT_ROOT/terraform/environments/dev"
INV_FILE="$PROJECT_ROOT/ansible/inventories/dev/hosts.ini"

cd "$TF_DIR"

MINIKUBE_IP=$(terraform output -raw minikube_public_ip)
SONAR_IP=$(terraform output -raw sonarqube_public_ip)
ARGO_IP=$(terraform output -raw argocd_public_ip)

cat > "$INV_FILE" <<EOF
[minikube]
minikube-dev ansible_host=${MINIKUBE_IP}

[sonarqube]
sonarqube-dev ansible_host=${SONAR_IP}

[argocd]
argocd-dev ansible_host=${ARGO_IP}

[devops_tools:children]
minikube
sonarqube
argocd
EOF

echo "✅ Ansible inventory generated at $INV_FILE"
