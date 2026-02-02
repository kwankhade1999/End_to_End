output "common_sg_id" {
  description = "Common security group ID"
  value       = aws_security_group.common.id
}

output "tools_sg_id" {
  description = "Tools security group ID"
  value       = aws_security_group.tools.id
}
