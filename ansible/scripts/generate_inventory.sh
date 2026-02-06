#!/bin/bash
set -e

# Resolve project root safely
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TF_DIR="$PROJECT_ROOT/terraform/environments/dev"
INV_FILE="$PROJECT_ROOT/ansible/inventories/dev/hosts.ini"

cd "$TF_DIR"

# Safe function to read terraform outputs
get_tf_output() {
  terraform output -raw "$1" 2>/dev/null || true
}

MINIKUBE_IP=$(get_tf_output minikube_public_ip)
SONAR_IP=$(get_tf_output sonarqube_public_ip)
ARGO_IP=$(get_tf_output argocd_public_ip)

# Start fresh inventory
cat > "$INV_FILE" <<EOF
EOF

# Minikube (optional)
if [[ -n "$MINIKUBE_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[minikube]
minikube-dev ansible_host=${MINIKUBE_IP}

EOF
fi

# SonarQube (optional)
if [[ -n "$SONAR_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[sonarqube]
sonarqube-dev ansible_host=${SONAR_IP}

EOF
fi

# ArgoCD (required now)
if [[ -n "$ARGO_IP" ]]; then
cat >> "$INV_FILE" <<EOF
[argocd]
argocd-dev ansible_host=${ARGO_IP}

EOF
fi

# Parent group
cat >> "$INV_FILE" <<EOF
[devops_tools:children]
minikube
sonarqube
argocd
EOF

echo "✅ Ansible inventory generated at $INV_FILE"
