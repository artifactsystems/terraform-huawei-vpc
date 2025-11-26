variable "a_vpc_id" {
  description = "ID of VPC A (requester side)."
  type        = string
}

variable "b_vpc_id" {
  description = "ID of VPC B (accepter side)."
  type        = string
}

variable "peering_connection_id" {
  description = "ID of the VPC peering connection used as next hop for routes."
  type        = string
}

variable "a_route_table_ids" {
  description = "List of route table IDs in VPC A to update (e.g., private/public)."
  type        = list(string)
  default     = []
}

variable "b_route_table_ids" {
  description = "List of route table IDs in VPC B to update (e.g., private/public)."
  type        = list(string)
  default     = []
}

variable "a_to_b_destination_cidrs" {
  description = "Destination CIDRs in VPC B that should be reachable from VPC A via peering."
  type        = list(string)
  default     = []
}

variable "b_to_a_destination_cidrs" {
  description = "Destination CIDRs in VPC A that should be reachable from VPC B via peering."
  type        = list(string)
  default     = []
}

variable "enable_routes_a_to_b" {
  description = "Whether to create routes in VPC A toward destinations in VPC B."
  type        = bool
  default     = true
}

variable "enable_routes_b_to_a" {
  description = "Whether to create routes in VPC B toward destinations in VPC A."
  type        = bool
  default     = true
}
