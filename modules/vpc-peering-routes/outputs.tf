output "a_to_b_route_ids" {
  description = "IDs of routes created in VPC A toward destinations in VPC B."
  value       = { for k, r in huaweicloud_vpc_route.a_to_b : k => r.id }
}

output "b_to_a_route_ids" {
  description = "IDs of routes created in VPC B toward destinations in VPC A."
  value       = { for k, r in huaweicloud_vpc_route.b_to_a : k => r.id }
}
