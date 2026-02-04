variable "env" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "Default EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "enable_minikube" {
  description = "Enable Minikube EC2"
  type        = bool
  default     = true
}

variable "enable_sonarqube" {
  description = "Enable SonarQube EC2"
  type        = bool
  default     = true
}

variable "enable_argocd" {
  description = "Enable ArgoCD EC2"
  type        = bool
  default     = true
}
