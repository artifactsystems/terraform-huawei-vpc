################################################################################
# Flow Log
################################################################################

output "flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = try(huaweicloud_vpc_flow_log.this[0].id, null)
}

output "flow_log_name" {
  description = "The name of the VPC Flow Log"
  value       = try(huaweicloud_vpc_flow_log.this[0].name, null)
}

output "flow_log_status" {
  description = "The status of the VPC Flow Log"
  value       = try(huaweicloud_vpc_flow_log.this[0].status, null)
}

################################################################################
# LTS Log Group
################################################################################

output "lts_group_id" {
  description = "ID of the LTS log group"
  value       = try(huaweicloud_lts_group.this[0].id, null)
}

output "lts_group_name" {
  description = "Name of the LTS log group"
  value       = try(huaweicloud_lts_group.this[0].group_name, null)
}

################################################################################
# LTS Log Stream
################################################################################

output "lts_stream_id" {
  description = "ID of the LTS log stream"
  value       = try(huaweicloud_lts_stream.this[0].id, null)
}

output "lts_stream_name" {
  description = "Name of the LTS log stream"
  value       = try(huaweicloud_lts_stream.this[0].stream_name, null)
}
