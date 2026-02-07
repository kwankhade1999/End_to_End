output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.this.private_ip
}

output "argocd_ec2_role_arn" {
  value = aws_iam_role.argocd_ec2_role.arn
}