################################################################################
# VPC
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(huaweicloud_vpc.this[0].id, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(huaweicloud_vpc.this[0].cidr, null)
}

output "vpc_status" {
  description = "The status of the VPC"
  value       = try(huaweicloud_vpc.this[0].status, null)
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = try(huaweicloud_vpc.this[0].secondary_cidrs, [])
}

################################################################################
# Public Subnets
################################################################################

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = huaweicloud_vpc_subnet.public[*].id
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(huaweicloud_vpc_subnet.public[*].cidr)
}

output "public_subnet_gateway_ips" {
  description = "List of gateway IPs of public subnets"
  value       = compact(huaweicloud_vpc_subnet.public[*].gateway_ip)
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = huaweicloud_vpc_route_table.public[*].id
}

################################################################################
# Private Subnets
################################################################################

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = huaweicloud_vpc_subnet.private[*].id
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(huaweicloud_vpc_subnet.private[*].cidr)
}

output "private_subnet_gateway_ips" {
  description = "List of gateway IPs of private subnets"
  value       = compact(huaweicloud_vpc_subnet.private[*].gateway_ip)
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = huaweicloud_vpc_route_table.private[*].id
}

################################################################################
# Database Subnets
################################################################################

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = huaweicloud_vpc_subnet.database[*].id
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = compact(huaweicloud_vpc_subnet.database[*].cidr)
}

output "database_subnet_gateway_ips" {
  description = "List of gateway IPs of database subnets"
  value       = compact(huaweicloud_vpc_subnet.database[*].gateway_ip)
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = huaweicloud_vpc_route_table.database[*].id
}

################################################################################
# Intra Subnets
################################################################################

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = huaweicloud_vpc_subnet.intra[*].id
}

output "intra_subnets_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = compact(huaweicloud_vpc_subnet.intra[*].cidr)
}

output "intra_subnet_gateway_ips" {
  description = "List of gateway IPs of intra subnets"
  value       = compact(huaweicloud_vpc_subnet.intra[*].gateway_ip)
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = huaweicloud_vpc_route_table.intra[*].id
}

################################################################################
# NAT Gateway
################################################################################

output "nat_ids" {
  description = "List of allocation IDs of Elastic IPs created for NAT Gateway"
  value       = huaweicloud_vpc_eip.nat[*].id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateway"
  value       = huaweicloud_vpc_eip.nat[*].address
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = huaweicloud_nat_gateway.this[*].id
}

################################################################################
# Static values (arguments)
################################################################################

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}

################################################################################
# Address Groups
################################################################################

output "address_group_ids" {
  description = "Map of Address Group IDs keyed by address group name"
  value       = try({ for k, v in huaweicloud_vpc_address_group.this : k => v.id }, {})
}

################################################################################
# Network ACLs
################################################################################

output "public_network_acl_id" {
  description = "ID of the network ACL for public subnets"
  value       = try(huaweicloud_vpc_network_acl.public[0].id, null)
}

output "private_network_acl_id" {
  description = "ID of the network ACL for private subnets"
  value       = try(huaweicloud_vpc_network_acl.private[0].id, null)
}

output "database_network_acl_id" {
  description = "ID of the network ACL for database subnets"
  value       = try(huaweicloud_vpc_network_acl.database[0].id, null)
}

output "intra_network_acl_id" {
  description = "ID of the network ACL for intra subnets"
  value       = try(huaweicloud_vpc_network_acl.intra[0].id, null)
}

output "default_network_acl_id" {
  description = "ID of the default network ACL"
  value       = try(huaweicloud_vpc_network_acl.default[0].id, null)
}

################################################################################
# VPC Flow Log
################################################################################

output "vpc_flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = try(module.vpc_flow_log[0].flow_log_id, null)
}

output "vpc_flow_log_name" {
  description = "The name of the VPC Flow Log"
  value       = try(module.vpc_flow_log[0].flow_log_name, null)
}

output "vpc_flow_log_status" {
  description = "The status of the VPC Flow Log"
  value       = try(module.vpc_flow_log[0].flow_log_status, null)
}

output "vpc_flow_log_lts_group_id" {
  description = "The ID of the LTS log group for VPC flow log (auto-created)"
  value       = try(module.vpc_flow_log[0].lts_group_id, null)
}

output "vpc_flow_log_lts_stream_id" {
  description = "The ID of the LTS log stream for VPC flow log (auto-created)"
  value       = try(module.vpc_flow_log[0].lts_stream_id, null)
}

################################################################################
# Private Subnet Flow Logs
################################################################################

output "private_subnet_flow_log_ids" {
  description = "Map of private subnet IDs to their flow log IDs"
  value       = { for k, v in module.private_subnet_flow_logs : k => v.flow_log_id }
}

output "private_subnet_flow_log_lts_group_ids" {
  description = "Map of private subnet IDs to their LTS log group IDs"
  value       = { for k, v in module.private_subnet_flow_logs : k => v.lts_group_id }
}

output "private_subnet_flow_log_lts_stream_ids" {
  description = "Map of private subnet IDs to their LTS log stream IDs"
  value       = { for k, v in module.private_subnet_flow_logs : k => v.lts_stream_id }
}

################################################################################
# Public Subnet Flow Logs
################################################################################

output "public_subnet_flow_log_ids" {
  description = "Map of public subnet IDs to their flow log IDs"
  value       = { for k, v in module.public_subnet_flow_logs : k => v.flow_log_id }
}

output "public_subnet_flow_log_lts_group_ids" {
  description = "Map of public subnet IDs to their LTS log group IDs"
  value       = { for k, v in module.public_subnet_flow_logs : k => v.lts_group_id }
}

output "public_subnet_flow_log_lts_stream_ids" {
  description = "Map of public subnet IDs to their LTS log stream IDs"
  value       = { for k, v in module.public_subnet_flow_logs : k => v.lts_stream_id }
}

################################################################################
# Database Subnet Flow Logs
################################################################################

output "database_subnet_flow_log_ids" {
  description = "Map of database subnet IDs to their flow log IDs"
  value       = { for k, v in module.database_subnet_flow_logs : k => v.flow_log_id }
}

output "database_subnet_flow_log_lts_group_ids" {
  description = "Map of database subnet IDs to their LTS log group IDs"
  value       = { for k, v in module.database_subnet_flow_logs : k => v.lts_group_id }
}

output "database_subnet_flow_log_lts_stream_ids" {
  description = "Map of database subnet IDs to their LTS log stream IDs"
  value       = { for k, v in module.database_subnet_flow_logs : k => v.lts_stream_id }
}

################################################################################
# VPC Peering
################################################################################

output "vpc_peering_ids" {
  description = "Map of VPC peering connection IDs keyed by peering key"
  value       = try({ for k, v in huaweicloud_vpc_peering_connection.this : k => v.id }, {})
}
