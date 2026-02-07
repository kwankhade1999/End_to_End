resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  user_data = var.user_data
  iam_instance_profile = aws_iam_instance_profile.argocd_profile.name
  
  tags = {
    Name = var.name
    Env  = var.env
  }
}
############################################
# IAM Role for ArgoCD EC2 (EKS Access)
############################################

resource "aws_iam_role" "argocd_ec2_role" {
  name = "${var.name}-argocd-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

############################################
# Attach EKS permissions
############################################

resource "aws_iam_role_policy_attachment" "eks_access" {
  role       = aws_iam_role.argocd_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

############################################
# Instance Profile
############################################

resource "aws_iam_instance_profile" "argocd_profile" {
  name = "${var.name}-argocd-instance-profile"
  role = aws_iam_role.argocd_ec2_role.name
}
