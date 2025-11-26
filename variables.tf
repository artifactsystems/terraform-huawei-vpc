variable "create_vpc" {
  description = "Controls if VPC should be created (affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
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

# ────────────────────────────────────────────────────────────────────────────
# ADDRESS GROUPS
# ────────────────────────────────────────────────────────────────────────────

variable "address_groups" {
  description = "Reusable IP/CIDR groups to manage as HuaweiCloud VPC Address Groups. Leave empty to create none."
  type = map(object({
    name       = optional(string)
    ip_version = optional(number, 4)
    addresses  = optional(list(string))
    ip_extra_set = optional(list(object({
      ip      = string
      remarks = optional(string)
    })), [])
    description           = optional(string)
    max_capacity          = optional(number)
    enterprise_project_id = optional(string)
    force_destroy         = optional(bool, false)
  }))
  default = {}

}

# ────────────────────────────────────────────────────────────────────────────
# VPC
# ────────────────────────────────────────────────────────────────────────────

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC. Each VPC can have 5 secondary CIDR blocks."
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "enterprise_project_id" {
  description = "The enterprise project ID for the VPC"
  type        = string
  default     = null
}

# ────────────────────────────────────────────────────────────────────────────
# SUBNETS
# ────────────────────────────────────────────────────────────────────────────

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags_per_az" {
  description = "Additional tags for the public subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "public_subnet_dhcp_enable" {
  description = "Specifies whether DHCP is enabled for public subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "public_subnet_primary_dns" {
  description = "Primary DNS server address for public subnets"
  type        = string
  default     = null
}

variable "public_subnet_secondary_dns" {
  description = "Secondary DNS server address for public subnets"
  type        = string
  default     = null
}

variable "public_subnet_dhcp_lease_time" {
  description = "DHCP lease time for public subnets. Value format is 'Xh'. -1 for unlimited, 1-30000 for hours"
  type        = string
  default     = null
}

variable "public_subnet_ntp_server_address" {
  description = "NTP server address for public subnets (comma-separated list, max 4 addresses)"
  type        = string
  default     = null
}

variable "public_subnet_dhcp_domain_name" {
  description = "Domain name configured for DHCP on public subnets"
  type        = string
  default     = null
}

variable "public_subnet_ipv6_enable" {
  description = "Specifies whether IPv6 is enabled for public subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "public_subnet_dhcp_ipv6_lease_time" {
  description = "DHCP IPv6 lease time for public subnets. Value format is 'Xh' (1-175200) or -1 for unlimited. Default: `2h`"
  type        = string
  default     = null
}

variable "public_subnet_dns_list" {
  description = "DNS server address list for public subnets. Use this if you need more than two DNS servers. This is superset of primary_dns and secondary_dns"
  type        = list(string)
  default     = []
}

variable "create_multiple_public_route_tables" {
  description = "Indicates whether to create a separate route table for each public subnet. Useful for granular control."
  type        = bool
  default     = false
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags_per_az" {
  description = "Additional tags for the private subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "private_subnet_dhcp_enable" {
  description = "Specifies whether DHCP is enabled for private subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "private_subnet_primary_dns" {
  description = "Primary DNS server address for private subnets"
  type        = string
  default     = null
}

variable "private_subnet_secondary_dns" {
  description = "Secondary DNS server address for private subnets"
  type        = string
  default     = null
}

variable "private_subnet_dhcp_lease_time" {
  description = "DHCP lease time for private subnets. Value format is 'Xh'. -1 for unlimited, 1-30000 for hours"
  type        = string
  default     = null
}

variable "private_subnet_ntp_server_address" {
  description = "NTP server address for private subnets (comma-separated list, max 4 addresses)"
  type        = string
  default     = null
}

variable "private_subnet_dhcp_domain_name" {
  description = "Domain name configured for DHCP on private subnets"
  type        = string
  default     = null
}

variable "private_subnet_ipv6_enable" {
  description = "Specifies whether IPv6 is enabled for private subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "private_subnet_dhcp_ipv6_lease_time" {
  description = "DHCP IPv6 lease time for private subnets. Value format is 'Xh' (1-175200) or -1 for unlimited. Default: `2h`"
  type        = string
  default     = null
}

variable "private_subnet_dns_list" {
  description = "DNS server address list for private subnets. Use this if you need more than two DNS servers. This is superset of primary_dns and secondary_dns"
  type        = list(string)
  default     = []
}

# ────────────────────────────────────────────────────────────────────────────
# PUBLIC NETWORK ACLS
# ────────────────────────────────────────────────────────────────────────────

variable "public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets"
  type        = bool
  default     = false
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      action            = "allow"
      ip_version        = 4
      protocol          = "tcp"
      source_ip_address = "0.0.0.0/0"
      destination_port  = "80,443"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      action            = "allow"
      ip_version        = 4
      protocol          = "tcp"
      source_ip_address = "0.0.0.0/0"
      destination_port  = "80,443"
    },
  ]
}

variable "public_acl_tags" {
  description = "Additional tags for the public subnets network ACL"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# PRIVATE NETWORK ACLS
# ────────────────────────────────────────────────────────────────────────────

variable "private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets"
  type        = bool
  default     = false
}

variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))
  default     = []
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACLs"
  type        = list(map(string))
  default     = []
}

variable "private_acl_tags" {
  description = "Additional tags for the private subnets network ACL"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# DATABASE SUBNETS
# ────────────────────────────────────────────────────────────────────────────

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnet_names" {
  description = "Explicit values to use in the Name tag on database subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "database_subnet_suffix" {
  description = "Suffix to append to database subnets name"
  type        = string
  default     = "db"
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets"
  type        = map(string)
  default     = {}
}

variable "database_subnet_dhcp_enable" {
  description = "Specifies whether DHCP is enabled for database subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "database_subnet_primary_dns" {
  description = "Primary DNS server address for database subnets"
  type        = string
  default     = null
}

variable "database_subnet_secondary_dns" {
  description = "Secondary DNS server address for database subnets"
  type        = string
  default     = null
}

variable "database_subnet_dhcp_lease_time" {
  description = "DHCP lease time for database subnets. Value format is 'Xh'. -1 for unlimited, 1-30000 for hours"
  type        = string
  default     = null
}

variable "database_subnet_ntp_server_address" {
  description = "NTP server address for database subnets (comma-separated list, max 4 addresses)"
  type        = string
  default     = null
}

variable "database_subnet_dhcp_domain_name" {
  description = "Domain name configured for DHCP on database subnets"
  type        = string
  default     = null
}

variable "database_subnet_ipv6_enable" {
  description = "Specifies whether IPv6 is enabled for database subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "database_subnet_dhcp_ipv6_lease_time" {
  description = "DHCP IPv6 lease time for database subnets. Value format is 'Xh' (1-175200) or -1 for unlimited. Default: `2h`"
  type        = string
  default     = null
}

variable "database_subnet_dns_list" {
  description = "DNS server address list for database subnets. Use this if you need more than two DNS servers. This is superset of primary_dns and secondary_dns"
  type        = list(string)
  default     = []
}

variable "create_database_subnet_route_table" {
  description = "Controls if separate route table for database should be created"
  type        = bool
  default     = false
}

variable "create_multiple_database_route_tables" {
  description = "Indicates whether to create a separate route table for each database subnet. Default: false (one route table for all database subnets)"
  type        = bool
  default     = false
}

variable "create_database_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created for database subnets to give internet access"
  type        = bool
  default     = false
}

# ────────────────────────────────────────────────────────────────────────────
# DATABASE NETWORK ACLS
# ────────────────────────────────────────────────────────────────────────────

variable "database_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for database subnets"
  type        = bool
  default     = false
}

variable "database_inbound_acl_rules" {
  description = "Database subnets inbound network ACLs"
  type        = list(map(string))
  default     = []
}

variable "database_outbound_acl_rules" {
  description = "Database subnets outbound network ACLs"
  type        = list(map(string))
  default     = []
}

variable "database_acl_tags" {
  description = "Additional tags for the database subnets network ACL"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# INTRA SUBNETS
# ────────────────────────────────────────────────────────────────────────────

variable "intra_subnets" {
  description = "A list of intra subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "intra_subnet_names" {
  description = "Explicit values to use in the Name tag on intra subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "intra_subnet_suffix" {
  description = "Suffix to append to intra subnets name"
  type        = string
  default     = "intra"
}

variable "intra_subnet_tags" {
  description = "Additional tags for the intra subnets"
  type        = map(string)
  default     = {}
}

variable "intra_subnet_dhcp_enable" {
  description = "Specifies whether DHCP is enabled for intra subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "intra_subnet_primary_dns" {
  description = "Primary DNS server address for intra subnets"
  type        = string
  default     = null
}

variable "intra_subnet_secondary_dns" {
  description = "Secondary DNS server address for intra subnets"
  type        = string
  default     = null
}

variable "intra_subnet_dhcp_lease_time" {
  description = "DHCP lease time for intra subnets. Value format is 'Xh'. -1 for unlimited, 1-30000 for hours"
  type        = string
  default     = null
}

variable "intra_subnet_ntp_server_address" {
  description = "NTP server address for intra subnets (comma-separated list, max 4 addresses)"
  type        = string
  default     = null
}

variable "intra_subnet_dhcp_domain_name" {
  description = "Domain name configured for DHCP on intra subnets"
  type        = string
  default     = null
}

variable "intra_subnet_ipv6_enable" {
  description = "Specifies whether IPv6 is enabled for intra subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "intra_subnet_dhcp_ipv6_lease_time" {
  description = "DHCP IPv6 lease time for intra subnets. Value format is 'Xh' (1-175200) or -1 for unlimited. Default: `2h`"
  type        = string
  default     = null
}

variable "intra_subnet_dns_list" {
  description = "DNS server address list for intra subnets. Use this if you need more than two DNS servers. This is superset of primary_dns and secondary_dns"
  type        = list(string)
  default     = []
}

variable "create_multiple_intra_route_tables" {
  description = "Indicates whether to create a separate route table for each intra subnet"
  type        = bool
  default     = false
}

# ────────────────────────────────────────────────────────────────────────────
# INTRA NETWORK ACLS
# ────────────────────────────────────────────────────────────────────────────

variable "intra_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for intra subnets"
  type        = bool
  default     = false
}

variable "intra_inbound_acl_rules" {
  description = "Intra subnets inbound network ACLs"
  type        = list(map(string))
  default     = []
}

variable "intra_outbound_acl_rules" {
  description = "Intra subnets outbound network ACLs"
  type        = list(map(string))
  default     = []
}

variable "intra_acl_tags" {
  description = "Additional tags for the intra subnets network ACL"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# NAT GATEWAY
# ────────────────────────────────────────────────────────────────────────────

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone"
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}

variable "nat_gateway_destination_cidr_block" {
  description = "Used to pass a custom destination route for private NAT Gateway. If not specified, the default 0.0.0.0/0 is used"
  type        = string
  default     = "0.0.0.0/0"
}

variable "create_private_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the private subnets via route table"
  type        = bool
  default     = true
}

variable "nat_eip_tags" {
  description = "Additional tags for the NAT Gateway EIPs"
  type        = map(string)
  default     = {}
}

variable "nat_eip_bandwidth_name" {
  description = "Name for the NAT EIP bandwidth. If not provided, will default to VPC name with AZ suffix"
  type        = string
  default     = null
}

variable "nat_eip_bandwidth_size" {
  description = "Size of the NAT EIP bandwidth in Mbit/s. Value ranges from 1 to 300"
  type        = number
  default     = 5
}

variable "nat_eip_bandwidth_charge_mode" {
  description = "Charging mode for the NAT EIP bandwidth. Can be 'traffic' or 'bandwidth'"
  type        = string
  default     = "traffic"
}

variable "nat_eip_publicip_type" {
  description = "Type of the NAT EIP. Can be '5_bgp' (dynamic BGP) or '5_sbgp' (static BGP)"
  type        = string
  default     = "5_bgp"
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT Gateways"
  type        = map(string)
  default     = {}
}

variable "nat_snat_rule_source_type" {
  description = "Source type for SNAT rules. 0 for VPC scenario (default), 1 for Direct Connect scenario"
  type        = number
  default     = 0
}

# ────────────────────────────────────────────────────────────────────────────
# DEFAULT NETWORK ACL
# ────────────────────────────────────────────────────────────────────────────

variable "manage_default_network_acl" {
  description = "Should be true to manage Default Network ACL"
  type        = bool
  default     = true
}

variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the Default Network ACL"
  type        = list(map(string))
  default = [
    {
      action            = "allow"
      ip_version        = 4
      protocol          = "tcp"
      source_ip_address = "0.0.0.0/0"
    },
  ]
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the Default Network ACL"
  type        = list(map(string))
  default = [
    {
      action                 = "allow"
      ip_version             = 4
      protocol               = "tcp"
      destination_ip_address = "0.0.0.0/0"
    },
  ]
}

variable "default_network_acl_tags" {
  description = "Additional tags for the Default Network ACL"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# VPC PEERING
# ────────────────────────────────────────────────────────────────────────────

variable "enable_vpc_peering" {
  description = "Whether to enable creation of VPC Peering connections"
  type        = bool
  default     = false
}

variable "vpc_peerings" {
  description = "Map of VPC peering definitions keyed by peering name/key"
  type = map(object({
    name           = optional(string)
    peer_vpc_id    = string
    peer_tenant_id = optional(string)
    description    = optional(string)
  }))
  default = {}
}

# ────────────────────────────────────────────────────────────────────────────
# VPC FLOW LOG
# ────────────────────────────────────────────────────────────────────────────

variable "enable_flow_log" {
  description = "Whether to enable VPC Flow Log"
  type        = bool
  default     = false
}

variable "flow_log_name" {
  description = "The name of the VPC flow log. If not provided, will default to VPC name with '-flow-log' suffix"
  type        = string
  default     = null
}

variable "flow_log_resource_type" {
  description = "Resource type for flow log. Valid values: 'vpc', 'network' (subnet), 'port' (NIC). Default: 'vpc'"
  type        = string
  default     = "vpc"
}

variable "flow_log_resource_id" {
  description = "Resource ID for flow log. If not provided and resource_type is 'vpc', will use the VPC ID created by this module"
  type        = string
  default     = null
}

variable "flow_log_traffic_type" {
  description = "Type of traffic to log. Valid values: 'all', 'accept', 'reject'. Default: 'all'"
  type        = string
  default     = "all"
}

variable "flow_log_enabled" {
  description = "Whether to enable the flow log function. Default: true"
  type        = bool
  default     = true
}

variable "flow_log_create_lts_resources" {
  description = "Whether to create LTS log group and stream automatically for VPC flow log. If false, you must provide flow_log_log_group_id and flow_log_log_stream_id"
  type        = bool
  default     = true
}

variable "flow_log_log_group_id" {
  description = "Existing LTS log group ID for flow log. Only used if flow_log_create_lts_resources is false"
  type        = string
  default     = null
}

variable "flow_log_log_stream_id" {
  description = "Existing LTS log stream ID for flow log. Only used if flow_log_create_lts_resources is false"
  type        = string
  default     = null
}

variable "flow_log_lts_group_name" {
  description = "Name of the LTS log group for VPC flow log. If not provided, will default to '{name}-flow-log-group'"
  type        = string
  default     = null
}

variable "flow_log_lts_group_ttl_in_days" {
  description = "Number of days to retain VPC flow logs in LTS. Valid values: 1-365"
  type        = number
  default     = 7
}

variable "flow_log_lts_stream_name" {
  description = "Name of the LTS log stream for VPC flow log. If not provided, will default to '{name}-flow-log-stream'"
  type        = string
  default     = null
}

variable "flow_log_lts_group_tags" {
  description = "Map of additional tags to add to the VPC flow log LTS log group"
  type        = map(string)
  default     = {}
}

variable "flow_log_lts_stream_tags" {
  description = "Map of additional tags to add to the VPC flow log LTS log stream"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# PRIVATE SUBNET FLOW LOGS
# ────────────────────────────────────────────────────────────────────────────

variable "enable_private_subnet_flow_logs" {
  description = "Whether to enable flow logs for all private subnets"
  type        = bool
  default     = false
}

variable "private_subnet_flow_log_name_override" {
  description = "Map of subnet IDs to custom flow log names. If not provided, names will be auto-generated"
  type        = map(string)
  default     = {}
}

variable "private_subnet_flow_log_traffic_type" {
  description = "Type of traffic to log for private subnets. Valid values: 'all', 'accept', 'reject'"
  type        = string
  default     = "all"
}

variable "private_subnet_flow_log_enabled" {
  description = "Whether to enable the private subnet flow log function"
  type        = bool
  default     = true
}

variable "private_subnet_flow_log_create_lts_resources" {
  description = "Whether to create LTS log group and stream automatically for private subnet flow logs"
  type        = bool
  default     = true
}

variable "private_subnet_flow_log_lts_group_name" {
  description = "Name of the LTS log group for private subnet flow logs. Auto-generated if not provided"
  type        = string
  default     = null
}

variable "private_subnet_flow_log_lts_group_ttl_in_days" {
  description = "Number of days to retain private subnet flow logs in LTS"
  type        = number
  default     = 7
}

variable "private_subnet_flow_log_lts_stream_name" {
  description = "Name of the LTS log stream for private subnet flow logs. Auto-generated if not provided"
  type        = string
  default     = null
}

variable "private_subnet_flow_log_log_group_id" {
  description = "Existing LTS log group ID for private subnet flow logs. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

variable "private_subnet_flow_log_log_stream_id" {
  description = "Existing LTS log stream ID for private subnet flow logs. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

variable "private_subnet_flow_log_tags" {
  description = "Additional tags for private subnet flow logs"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# PUBLIC SUBNET FLOW LOGS
# ────────────────────────────────────────────────────────────────────────────

variable "enable_public_subnet_flow_logs" {
  description = "Whether to enable flow logs for all public subnets"
  type        = bool
  default     = false
}

variable "public_subnet_flow_log_name_override" {
  description = "Map of subnet IDs to custom flow log names. If not provided, names will be auto-generated"
  type        = map(string)
  default     = {}
}

variable "public_subnet_flow_log_traffic_type" {
  description = "Type of traffic to log for public subnets. Valid values: 'all', 'accept', 'reject'"
  type        = string
  default     = "all"
}

variable "public_subnet_flow_log_enabled" {
  description = "Whether to enable the public subnet flow log function"
  type        = bool
  default     = true
}

variable "public_subnet_flow_log_create_lts_resources" {
  description = "Whether to create LTS log group and stream automatically for public subnet flow logs"
  type        = bool
  default     = true
}

variable "public_subnet_flow_log_lts_group_name" {
  description = "Name of the LTS log group for public subnet flow logs. Auto-generated if not provided"
  type        = string
  default     = null
}

variable "public_subnet_flow_log_lts_group_ttl_in_days" {
  description = "Number of days to retain public subnet flow logs in LTS"
  type        = number
  default     = 7
}

variable "public_subnet_flow_log_lts_stream_name" {
  description = "Name of the LTS log stream for public subnet flow logs. Auto-generated if not provided"
  type        = string
  default     = null
}

variable "public_subnet_flow_log_log_group_id" {
  description = "Existing LTS log group ID for public subnet flow logs. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

variable "public_subnet_flow_log_log_stream_id" {
  description = "Existing LTS log stream ID for public subnet flow logs. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

variable "public_subnet_flow_log_tags" {
  description = "Additional tags for public subnet flow logs"
  type        = map(string)
  default     = {}
}

# ────────────────────────────────────────────────────────────────────────────
# DATABASE SUBNET FLOW LOGS
# ────────────────────────────────────────────────────────────────────────────

variable "enable_database_subnet_flow_logs" {
  description = "Whether to enable flow logs for all database subnets"
  type        = bool
  default     = false
}

variable "database_subnet_flow_log_name_override" {
  description = "Map of subnet IDs to custom flow log names. If not provided, names will be auto-generated"
  type        = map(string)
  default     = {}
}

variable "database_subnet_flow_log_traffic_type" {
  description = "Type of traffic to log for database subnets. Valid values: 'all', 'accept', 'reject'"
  type        = string
  default     = "all"
}

variable "database_subnet_flow_log_enabled" {
  description = "Whether to enable the database subnet flow log function"
  type        = bool
  default     = true
}

variable "database_subnet_flow_log_create_lts_resources" {
  description = "Whether to create LTS log group and stream automatically for database subnet flow logs"
  type        = bool
  default     = true
}

variable "database_subnet_flow_log_lts_group_name" {
  description = "Name of the LTS log group for database subnet flow logs. Auto-generated if not provided"
  type        = string
  default     = null
}

variable "database_subnet_flow_log_lts_group_ttl_in_days" {
  description = "Number of days to retain database subnet flow logs in LTS"
  type        = number
  default     = 7
}

variable "database_subnet_flow_log_lts_stream_name" {
  description = "Name of the LTS log stream for database subnet flow logs. Auto-generated if not provided"
  type        = string
  default     = null
}

variable "database_subnet_flow_log_log_group_id" {
  description = "Existing LTS log group ID for database subnet flow logs. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

variable "database_subnet_flow_log_log_stream_id" {
  description = "Existing LTS log stream ID for database subnet flow logs. Only used if create_lts_resources is false"
  type        = string
  default     = null
}

variable "database_subnet_flow_log_tags" {
  description = "Additional tags for database subnet flow logs"
  type        = map(string)
  default     = {}
}
