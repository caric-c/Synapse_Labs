# show path : Synapse_Labs/terraform/modules/vpc/output.tf

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

output "security_group_ids" {
  description = "Map of security group IDs"
  value = {
    alb         = aws_security_group.alb.id
    application = aws_security_group.application.id
    database    = aws_security_group.database.id
    bastion     = var.enable_bastion ? aws_security_group.bastion[0].id : null
  }
}
