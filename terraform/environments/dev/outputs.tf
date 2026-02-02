########################################
# VPC Outputs
########################################
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc.public_subnet_id
}

########################################
# Minikube EC2 Outputs
########################################
output "minikube_instance_id" {
  description = "Minikube EC2 instance ID"
  value       = module.minikube.instance_id
}

output "minikube_public_ip" {
  description = "Minikube public IP"
  value       = module.minikube.public_ip
}

########################################
# SonarQube EC2 Outputs
########################################
output "sonarqube_instance_id" {
  description = "SonarQube EC2 instance ID"
  value       = module.sonarqube.instance_id
}

output "sonarqube_public_ip" {
  description = "SonarQube public IP"
  value       = module.sonarqube.public_ip
}

########################################
# ArgoCD EC2 Outputs
########################################
output "argocd_instance_id" {
  description = "ArgoCD EC2 instance ID"
  value       = module.argocd.instance_id
}

output "argocd_public_ip" {
  description = "ArgoCD public IP"
  value       = module.argocd.public_ip
}
