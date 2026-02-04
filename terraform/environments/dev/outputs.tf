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
  value       = var.enable_minikube ? module.minikube[0].instance_id : null
}

output "minikube_public_ip" {
  description = "Minikube public IP"
  value       = var.enable_minikube ? module.minikube[0].public_ip : null
}

########################################
# SonarQube EC2 Outputs
########################################
output "sonarqube_instance_id" {
  description = "SonarQube EC2 instance ID"
  value       = var.enable_sonarqube ? module.sonarqube[0].instance_id : null
}

output "sonarqube_public_ip" {
  description = "SonarQube public IP"
  value       = var.enable_sonarqube ? module.sonarqube[0].public_ip : null
}

########################################
# ArgoCD EC2 Outputs
########################################
output "argocd_instance_id" {
  description = "ArgoCD EC2 instance ID"
  value       = var.enable_argocd ? module.argocd[0].instance_id : null
}

output "argocd_public_ip" {
  description = "ArgoCD public IP"
  value       = var.enable_argocd ? module.argocd[0].public_ip : null
}


########################################
# EKS Cluster Outputs
########################################
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

