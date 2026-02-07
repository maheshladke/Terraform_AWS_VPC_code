################################################################################
# VPC Outputs
################################################################################

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

################################################################################
# Private Subnet Outputs
################################################################################

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

################################################################################
# Route Table Outputs
################################################################################

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private Route Table ID (if NAT enabled)"
  value       = var.enable_nat_gateway ? aws_route_table.private[0].id : "Not created"
}

################################################################################
# NAT Gateway Outputs
################################################################################

output "nat_gateway_ids" {
  description = "NAT Gateway IDs (if enabled)"
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[*].id : []
}

output "nat_gateway_eips" {
  description = "Elastic IPs associated with NAT Gateways"
  value       = var.enable_nat_gateway ? aws_eip.nat[*].public_ip : []
}

################################################################################
# Network ACL Outputs
################################################################################

output "public_nacl_id" {
  description = "Public Network ACL ID"
  value       = aws_network_acl.public.id
}

output "private_nacl_id" {
  description = "Private Network ACL ID"
  value       = aws_network_acl.private.id
}

################################################################################
# Security Group Outputs
################################################################################

output "default_security_group_id" {
  description = "Default Security Group ID"
  value       = aws_security_group.default.id
}

################################################################################
# Availability Zone Outputs
################################################################################

output "availability_zones" {
  description = "Available zones used for subnets"
  value       = data.aws_availability_zones.available.names
}
