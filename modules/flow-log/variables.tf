variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Flow Log
################################################################################

variable "name" {
  description = "Name of the VPC flow log"
  type        = string
  default     = ""
}

variable "resource_type" {
  description = "Resource type for flow log. Valid values: 'vpc', 'network' (subnet), 'port' (NIC)"
  type        = string
  default     = "vpc"
}

variable "resource_id" {
  description = "Resource ID for flow log (VPC ID, Subnet ID, or NIC ID depending on resource_type)"
  type        = string
}

variable "traffic_type" {
  description = "Type of traffic to log. Valid values: 'all', 'accept', 'reject'"
  type        = string
  default     = "all"
}

variable "enabled" {
  description = "Whether to enable the flow log function"
  type        = bool
  default     = true
}

################################################################################
# LTS Resources (Automatic Creation)
################################################################################

variable "create_lts_resources" {
  description = "Whether to create LTS log group and stream automatically. If false, you must provide log_group_id and log_stream_id"
  type        = bool
  default     = true
}

variable "log_group_id" {
  description = "Existing LTS log group ID. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

variable "log_stream_id" {
  description = "Existing LTS log stream ID. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

################################################################################
# LTS Log Group
################################################################################

variable "lts_group_name" {
  description = "Name of the LTS log group. If not provided, will default to '{name}-group'"
  type        = string
  default     = null
}

variable "lts_group_ttl_in_days" {
  description = "Number of days to retain logs in LTS. Valid values: 1-365"
  type        = number
  default     = 7
}

variable "lts_group_tags" {
  description = "Map of additional tags to add to the LTS log group"
  type        = map(string)
  default     = {}
}

################################################################################
# LTS Log Stream
################################################################################

variable "lts_stream_name" {
  description = "Name of the LTS log stream. If not provided, will default to '{name}-stream'"
  type        = string
  default     = null
}

variable "lts_stream_tags" {
  description = "Map of additional tags to add to the LTS log stream"
  type        = map(string)
  default     = {}
}
