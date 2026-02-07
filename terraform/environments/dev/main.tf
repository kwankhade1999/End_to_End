########################################
# VPC
########################################
module "vpc" {
  source = "../../modules/vpc"

  env    = var.env
  region = var.aws_region
}

########################################
# Security Groups
########################################
module "security_groups" {
  source = "../../modules/security-groups"

  env    = var.env
  vpc_id = module.vpc.vpc_id
}

########################################
# AMI (Ubuntu 22.04 LTS)
########################################
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

########################################
# Minikube EC2
########################################
module "minikube" {
  source = "../../modules/ec2"
  count  = var.enable_minikube ? 1 : 0

  name               = "minikube-${var.env}"
  env                = var.env
  ami                = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  key_name           = var.key_name
  security_group_ids = [
    module.security_groups.common_sg_id,
    module.security_groups.tools_sg_id
  ]
}

########################################
# SonarQube EC2
########################################
module "sonarqube" {
  source = "../../modules/ec2"
  count  = var.enable_sonarqube ? 1 : 0

  name               = "sonarqube-${var.env}"
  env                = var.env
  ami                = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  key_name           = var.key_name
  security_group_ids = [
    module.security_groups.common_sg_id,
    module.security_groups.tools_sg_id
  ]
}

########################################
# ArgoCD EC2
########################################
module "argocd" {
  source = "../../modules/ec2"
  count  = var.enable_argocd ? 1 : 0

  name               = "argocd-${var.env}"
  env                = var.env
  ami                = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  key_name           = var.key_name
  security_group_ids = [
    module.security_groups.common_sg_id,
    module.security_groups.tools_sg_id
  ]
}

########################################
# EKS Cluster
########################################


module "eks" {
  source = "../../modules/eks"

  cluster_name = "dev-eks-cluster"
  subnet_ids   = module.vpc.public_subnet_ids
 
  argocd_ec2_role_arn = module.ec2.argocd_ec2_role_arn
}