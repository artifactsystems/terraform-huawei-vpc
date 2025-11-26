################################################################################
# Complete Flow Log Example Outputs
################################################################################

output "vpc_flow_log_id" {
  description = "VPC-level flow log ID"
  value       = module.vpc_complete_flow_logs.vpc_flow_log_id
}

output "vpc_flow_log_lts_group_id" {
  description = "VPC flow log LTS group ID (auto-created)"
  value       = module.vpc_complete_flow_logs.vpc_flow_log_lts_group_id
}

output "vpc_flow_log_lts_stream_id" {
  description = "VPC flow log LTS stream ID (auto-created)"
  value       = module.vpc_complete_flow_logs.vpc_flow_log_lts_stream_id
}

output "private_subnet_flow_log_ids" {
  description = "Map of private subnet IDs to their flow log IDs"
  value       = module.vpc_complete_flow_logs.private_subnet_flow_log_ids
}

output "private_subnet_flow_log_lts_group_ids" {
  description = "Map of private subnet IDs to their LTS group IDs (auto-created)"
  value       = module.vpc_complete_flow_logs.private_subnet_flow_log_lts_group_ids
}

output "public_subnet_flow_log_ids" {
  description = "Map of public subnet IDs to their flow log IDs"
  value       = module.vpc_complete_flow_logs.public_subnet_flow_log_ids
}

output "public_subnet_flow_log_lts_group_ids" {
  description = "Map of public subnet IDs to their LTS group IDs (auto-created)"
  value       = module.vpc_complete_flow_logs.public_subnet_flow_log_lts_group_ids
}

output "database_subnet_flow_log_ids" {
  description = "Map of database subnet IDs to their flow log IDs"
  value       = module.vpc_complete_flow_logs.database_subnet_flow_log_ids
}

output "database_subnet_flow_log_lts_group_ids" {
  description = "Map of database subnet IDs to their LTS group IDs (auto-created)"
  value       = module.vpc_complete_flow_logs.database_subnet_flow_log_lts_group_ids
}
