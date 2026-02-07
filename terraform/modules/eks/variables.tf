variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for EKS"
  type        = list(string)
}

variable "argocd_ec2_role_arn" {
  description = "IAM role ARN for ArgoCD EC2 jump host"
  type        = string
}