locals {
  len_public_subnets   = length(var.public_subnets)
  len_private_subnets  = length(var.private_subnets)
  len_database_subnets = length(var.database_subnets)
  len_intra_subnets    = length(var.intra_subnets)

  max_subnet_length = max(
    local.len_private_subnets,
    local.len_public_subnets,
    local.len_database_subnets,
    local.len_intra_subnets,
  )

  vpc_id = try(huaweicloud_vpc.this[0].id, "")

  create_vpc = var.create_vpc
}

################################################################################
# VPC Peering - Locals
################################################################################

locals {
  create_vpc_peering = local.create_vpc && var.enable_vpc_peering && length(var.vpc_peerings) > 0
}

################################################################################
# VPC
################################################################################

resource "huaweicloud_vpc" "this" {
  count = local.create_vpc ? 1 : 0

  region = var.region

  name                  = var.name
  cidr                  = var.cidr
  secondary_cidrs       = var.secondary_cidr_blocks
  enterprise_project_id = var.enterprise_project_id
  // enhanced_local_route  = var.enable_enhanced_local_route

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )

  timeouts {
    create = "10m"
    delete = "3m"
  }
}

################################################################################
# VPC Peering Connections
################################################################################

resource "huaweicloud_vpc_peering_connection" "this" {
  for_each = local.create_vpc_peering ? var.vpc_peerings : {}

  region = var.region

  name           = coalesce(try(each.value.name, null), each.key)
  vpc_id         = local.vpc_id
  peer_vpc_id    = each.value.peer_vpc_id
  peer_tenant_id = try(each.value.peer_tenant_id, null)
  description    = try(each.value.description, null)

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

################################################################################
# Public Subnets
################################################################################

locals {
  create_public_subnets = local.create_vpc && local.len_public_subnets > 0
}

resource "huaweicloud_vpc_subnet" "public" {
  count = local.create_public_subnets && (!var.one_nat_gateway_per_az || local.len_public_subnets >= length(var.azs)) ? local.len_public_subnets : 0

  region = var.region

  name = try(
    var.public_subnet_names[count.index],
    format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
  )

  cidr              = element(var.public_subnets, count.index)
  gateway_ip        = cidrhost(element(var.public_subnets, count.index), 1)
  vpc_id            = local.vpc_id
  availability_zone = length(var.azs) > 0 ? element(var.azs, count.index) : null

  ipv6_enable          = var.public_subnet_ipv6_enable
  dhcp_enable          = var.public_subnet_dhcp_enable
  primary_dns          = var.public_subnet_primary_dns
  secondary_dns        = var.public_subnet_secondary_dns
  dns_list             = var.public_subnet_dns_list
  ntp_server_address   = var.public_subnet_ntp_server_address
  dhcp_lease_time      = var.public_subnet_dhcp_lease_time
  dhcp_ipv6_lease_time = var.public_subnet_dhcp_ipv6_lease_time
  dhcp_domain_name     = var.public_subnet_dhcp_domain_name

  tags = merge(
    {
      Name = try(
        var.public_subnet_names[count.index],
        format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
      )
      Type = var.public_subnet_suffix
    },
    var.tags,
    var.public_subnet_tags,
    lookup(var.public_subnet_tags_per_az, element(var.azs, count.index), {})
  )

  timeouts {
    create = "5m"
    delete = "10m"
  }
}

################################################################################
# Public Route Tables
################################################################################

locals {
  num_public_route_tables = var.create_multiple_public_route_tables ? local.len_public_subnets : 1
}

resource "huaweicloud_vpc_route_table" "public" {
  count = local.create_public_subnets ? local.num_public_route_tables : 0

  region = var.region

  vpc_id      = local.vpc_id
  name        = var.create_multiple_public_route_tables ? format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index)) : "${var.name}-${var.public_subnet_suffix}"
  description = "Public route table"

  subnets = var.create_multiple_public_route_tables ? [element(huaweicloud_vpc_subnet.public[*].id, count.index)] : huaweicloud_vpc_subnet.public[*].id

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

################################################################################
# Public Network ACLs
################################################################################

resource "huaweicloud_vpc_network_acl" "public" {
  count = local.create_public_subnets && var.public_dedicated_network_acl ? 1 : 0

  region = var.region

  name                  = "${var.name}-${var.public_subnet_suffix}"
  enterprise_project_id = var.enterprise_project_id
  enabled               = true

  dynamic "ingress_rules" {
    for_each = var.public_inbound_acl_rules
    content {
      action                 = ingress_rules.value.action
      protocol               = ingress_rules.value.protocol
      name                   = try(ingress_rules.value.name, null)
      description            = try(ingress_rules.value.description, null)
      ip_version             = try(ingress_rules.value.ip_version, 4)
      source_ip_address      = try(ingress_rules.value.source_ip_address, null)
      source_port            = try(ingress_rules.value.source_port, null)
      destination_ip_address = try(ingress_rules.value.destination_ip_address, null)
      destination_port       = try(ingress_rules.value.destination_port, null)
    }
  }

  dynamic "egress_rules" {
    for_each = var.public_outbound_acl_rules
    content {
      action                 = egress_rules.value.action
      protocol               = egress_rules.value.protocol
      name                   = try(egress_rules.value.name, null)
      description            = try(egress_rules.value.description, null)
      ip_version             = try(egress_rules.value.ip_version, 4)
      source_ip_address      = try(egress_rules.value.source_ip_address, null)
      source_port            = try(egress_rules.value.source_port, null)
      destination_ip_address = try(egress_rules.value.destination_ip_address, null)
      destination_port       = try(egress_rules.value.destination_port, null)
    }
  }

  dynamic "associated_subnets" {
    for_each = huaweicloud_vpc_subnet.public[*].id
    content {
      subnet_id = associated_subnets.value
    }
  }

  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}" },
    var.tags,
    var.public_acl_tags,
  )
}

################################################################################
# Private Subnets
################################################################################

locals {
  create_private_subnets = local.create_vpc && local.len_private_subnets > 0
}

resource "huaweicloud_vpc_subnet" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  region = var.region

  name = try(
    var.private_subnet_names[count.index],
    format("${var.name}-${var.private_subnet_suffix}-%s", element(var.azs, count.index))
  )
  cidr              = element(var.private_subnets, count.index)
  gateway_ip        = cidrhost(element(var.private_subnets, count.index), 1)
  vpc_id            = local.vpc_id
  availability_zone = length(var.azs) > 0 ? element(var.azs, count.index) : null

  ipv6_enable          = var.private_subnet_ipv6_enable
  dhcp_enable          = var.private_subnet_dhcp_enable
  primary_dns          = var.private_subnet_primary_dns
  secondary_dns        = var.private_subnet_secondary_dns
  dns_list             = var.private_subnet_dns_list
  ntp_server_address   = var.private_subnet_ntp_server_address
  dhcp_lease_time      = var.private_subnet_dhcp_lease_time
  dhcp_ipv6_lease_time = var.private_subnet_dhcp_ipv6_lease_time
  dhcp_domain_name     = var.private_subnet_dhcp_domain_name

  tags = merge(
    {
      Name = try(
        var.private_subnet_names[count.index],
        format("${var.name}-${var.private_subnet_suffix}-%s", element(var.azs, count.index))
      )
      Type = var.private_subnet_suffix
    },
    var.tags,
    var.private_subnet_tags,
    lookup(var.private_subnet_tags_per_az, element(var.azs, count.index), {})
  )

  timeouts {
    create = "5m"
    delete = "10m"
  }
}

################################################################################
# Private Route Tables
################################################################################

resource "huaweicloud_vpc_route_table" "private" {
  count = local.create_private_subnets ? local.nat_gateway_count : 0

  region = var.region

  vpc_id      = local.vpc_id
  name        = var.single_nat_gateway ? "${var.name}-${var.private_subnet_suffix}" : format("${var.name}-${var.private_subnet_suffix}-%s", element(var.azs, count.index))
  description = "Private route table"

  subnets = var.single_nat_gateway ? huaweicloud_vpc_subnet.private[*].id : [element(huaweicloud_vpc_subnet.private[*].id, count.index)]

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

################################################################################
# Private Network ACLs
################################################################################

locals {
  create_private_network_acl = local.create_private_subnets && var.private_dedicated_network_acl
}

resource "huaweicloud_vpc_network_acl" "private" {
  count = local.create_private_network_acl ? 1 : 0

  region = var.region

  name                  = "${var.name}-${var.private_subnet_suffix}"
  enterprise_project_id = var.enterprise_project_id
  enabled               = true

  dynamic "ingress_rules" {
    for_each = var.private_inbound_acl_rules
    content {
      action                 = ingress_rules.value.action
      protocol               = ingress_rules.value.protocol
      name                   = try(ingress_rules.value.name, null)
      description            = try(ingress_rules.value.description, null)
      ip_version             = try(ingress_rules.value.ip_version, 4)
      source_ip_address      = try(ingress_rules.value.source_ip_address, null)
      source_port            = try(ingress_rules.value.source_port, null)
      destination_ip_address = try(ingress_rules.value.destination_ip_address, null)
      destination_port       = try(ingress_rules.value.destination_port, null)
    }
  }

  dynamic "egress_rules" {
    for_each = var.private_outbound_acl_rules
    content {
      action                 = egress_rules.value.action
      protocol               = egress_rules.value.protocol
      name                   = try(egress_rules.value.name, null)
      description            = try(egress_rules.value.description, null)
      ip_version             = try(egress_rules.value.ip_version, 4)
      source_ip_address      = try(egress_rules.value.source_ip_address, null)
      source_port            = try(egress_rules.value.source_port, null)
      destination_ip_address = try(egress_rules.value.destination_ip_address, null)
      destination_port       = try(egress_rules.value.destination_port, null)
    }
  }

  dynamic "associated_subnets" {
    for_each = huaweicloud_vpc_subnet.private[*].id
    content {
      subnet_id = associated_subnets.value
    }
  }

  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}" },
    var.tags,
    var.private_acl_tags,
  )
}

################################################################################
# Database Subnets
################################################################################

locals {
  create_database_subnets = local.create_vpc && local.len_database_subnets > 0
}

resource "huaweicloud_vpc_subnet" "database" {
  count = local.create_database_subnets ? local.len_database_subnets : 0

  region = var.region

  name = try(
    var.database_subnet_names[count.index],
    format("${var.name}-${var.database_subnet_suffix}-%s", element(var.azs, count.index))
  )

  cidr              = element(var.database_subnets, count.index)
  gateway_ip        = cidrhost(element(var.database_subnets, count.index), 1)
  vpc_id            = local.vpc_id
  availability_zone = length(var.azs) > 0 ? element(var.azs, count.index) : null

  ipv6_enable          = var.database_subnet_ipv6_enable
  dhcp_enable          = var.database_subnet_dhcp_enable
  primary_dns          = var.database_subnet_primary_dns
  secondary_dns        = var.database_subnet_secondary_dns
  dns_list             = var.database_subnet_dns_list
  ntp_server_address   = var.database_subnet_ntp_server_address
  dhcp_lease_time      = var.database_subnet_dhcp_lease_time
  dhcp_ipv6_lease_time = var.database_subnet_dhcp_ipv6_lease_time
  dhcp_domain_name     = var.database_subnet_dhcp_domain_name

  tags = merge(
    {
      Name = try(
        var.database_subnet_names[count.index],
        format("${var.name}-${var.database_subnet_suffix}-%s", element(var.azs, count.index))
      )
      Type = var.database_subnet_suffix
    },
    var.tags,
    var.database_subnet_tags,
  )

  timeouts {
    create = "5m"
    delete = "10m"
  }
}

################################################################################
# Database Route Tables
################################################################################

locals {
  create_database_route_table = local.create_database_subnets && var.create_database_subnet_route_table
  num_database_route_tables   = var.create_multiple_database_route_tables ? local.len_database_subnets : 1
}

resource "huaweicloud_vpc_route_table" "database" {
  count = local.create_database_route_table ? local.num_database_route_tables : 0

  region = var.region

  vpc_id      = local.vpc_id
  name        = var.create_multiple_database_route_tables ? format("${var.name}-${var.database_subnet_suffix}-%s", element(var.azs, count.index)) : "${var.name}-${var.database_subnet_suffix}"
  description = "Database route table"

  subnets = var.create_multiple_database_route_tables ? [element(huaweicloud_vpc_subnet.database[*].id, count.index)] : huaweicloud_vpc_subnet.database[*].id

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "huaweicloud_vpc_route" "database_nat_gateway" {
  count = local.create_database_route_table && var.enable_nat_gateway && var.create_database_nat_gateway_route ? local.num_database_route_tables : 0

  region = var.region

  vpc_id         = local.vpc_id
  destination    = var.nat_gateway_destination_cidr_block
  type           = "nat"
  nexthop        = element(huaweicloud_nat_gateway.this[*].id, var.single_nat_gateway ? 0 : count.index)
  route_table_id = element(huaweicloud_vpc_route_table.database[*].id, count.index)

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

################################################################################
# Database Network ACLs
################################################################################

locals {
  create_database_network_acl = local.create_database_subnets && var.database_dedicated_network_acl
}

resource "huaweicloud_vpc_network_acl" "database" {
  count = local.create_database_network_acl ? 1 : 0

  region = var.region

  name                  = "${var.name}-${var.database_subnet_suffix}"
  enterprise_project_id = var.enterprise_project_id
  enabled               = true

  dynamic "ingress_rules" {
    for_each = var.database_inbound_acl_rules
    content {
      action                 = ingress_rules.value.action
      protocol               = ingress_rules.value.protocol
      name                   = try(ingress_rules.value.name, null)
      description            = try(ingress_rules.value.description, null)
      ip_version             = try(ingress_rules.value.ip_version, 4)
      source_ip_address      = try(ingress_rules.value.source_ip_address, null)
      source_port            = try(ingress_rules.value.source_port, null)
      destination_ip_address = try(ingress_rules.value.destination_ip_address, null)
      destination_port       = try(ingress_rules.value.destination_port, null)
    }
  }

  dynamic "egress_rules" {
    for_each = var.database_outbound_acl_rules
    content {
      action                 = egress_rules.value.action
      protocol               = egress_rules.value.protocol
      name                   = try(egress_rules.value.name, null)
      description            = try(egress_rules.value.description, null)
      ip_version             = try(egress_rules.value.ip_version, 4)
      source_ip_address      = try(egress_rules.value.source_ip_address, null)
      source_port            = try(egress_rules.value.source_port, null)
      destination_ip_address = try(egress_rules.value.destination_ip_address, null)
      destination_port       = try(egress_rules.value.destination_port, null)
    }
  }

  dynamic "associated_subnets" {
    for_each = huaweicloud_vpc_subnet.database[*].id
    content {
      subnet_id = associated_subnets.value
    }
  }

  tags = merge(
    { "Name" = "${var.name}-${var.database_subnet_suffix}" },
    var.tags,
    var.database_acl_tags,
  )
}

################################################################################
# Intra Subnets
################################################################################

locals {
  create_intra_subnets = local.create_vpc && local.len_intra_subnets > 0
}

resource "huaweicloud_vpc_subnet" "intra" {
  count = local.create_intra_subnets ? local.len_intra_subnets : 0

  region = var.region

  name = try(
    var.intra_subnet_names[count.index],
    format("${var.name}-${var.intra_subnet_suffix}-%s", element(var.azs, count.index))
  )
  cidr              = element(var.intra_subnets, count.index)
  gateway_ip        = cidrhost(element(var.intra_subnets, count.index), 1)
  vpc_id            = local.vpc_id
  availability_zone = length(var.azs) > 0 ? element(var.azs, count.index) : null

  ipv6_enable          = var.intra_subnet_ipv6_enable
  dhcp_enable          = var.intra_subnet_dhcp_enable
  primary_dns          = var.intra_subnet_primary_dns
  secondary_dns        = var.intra_subnet_secondary_dns
  dns_list             = var.intra_subnet_dns_list
  ntp_server_address   = var.intra_subnet_ntp_server_address
  dhcp_lease_time      = var.intra_subnet_dhcp_lease_time
  dhcp_ipv6_lease_time = var.intra_subnet_dhcp_ipv6_lease_time
  dhcp_domain_name     = var.intra_subnet_dhcp_domain_name

  tags = merge(
    {
      Name = try(
        var.intra_subnet_names[count.index],
        format("${var.name}-${var.intra_subnet_suffix}-%s", element(var.azs, count.index))
      )
      Type = var.intra_subnet_suffix
    },
    var.tags,
    var.intra_subnet_tags,
  )

  timeouts {
    create = "5m"
    delete = "10m"
  }
}

################################################################################
# Intra Route Tables
################################################################################

locals {
  num_intra_route_tables = var.create_multiple_intra_route_tables ? local.len_intra_subnets : 1
}

resource "huaweicloud_vpc_route_table" "intra" {
  count = local.create_intra_subnets ? local.num_intra_route_tables : 0

  region = var.region

  vpc_id      = local.vpc_id
  name        = var.create_multiple_intra_route_tables ? format("${var.name}-${var.intra_subnet_suffix}-%s", element(var.azs, count.index)) : "${var.name}-${var.intra_subnet_suffix}"
  description = "Intra route table"

  subnets = var.create_multiple_intra_route_tables ? [element(huaweicloud_vpc_subnet.intra[*].id, count.index)] : huaweicloud_vpc_subnet.intra[*].id

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

################################################################################
# Intra Network ACLs
################################################################################

locals {
  create_intra_network_acl = local.create_intra_subnets && var.intra_dedicated_network_acl
}

resource "huaweicloud_vpc_network_acl" "intra" {
  count = local.create_intra_network_acl ? 1 : 0

  region = var.region

  name                  = "${var.name}-${var.intra_subnet_suffix}"
  enterprise_project_id = var.enterprise_project_id
  enabled               = true

  dynamic "ingress_rules" {
    for_each = var.intra_inbound_acl_rules
    content {
      action                 = ingress_rules.value.action
      protocol               = ingress_rules.value.protocol
      name                   = try(ingress_rules.value.name, null)
      description            = try(ingress_rules.value.description, null)
      ip_version             = try(ingress_rules.value.ip_version, 4)
      source_ip_address      = try(ingress_rules.value.source_ip_address, null)
      source_port            = try(ingress_rules.value.source_port, null)
      destination_ip_address = try(ingress_rules.value.destination_ip_address, null)
      destination_port       = try(ingress_rules.value.destination_port, null)
    }
  }

  dynamic "egress_rules" {
    for_each = var.intra_outbound_acl_rules
    content {
      action                 = egress_rules.value.action
      protocol               = egress_rules.value.protocol
      name                   = try(egress_rules.value.name, null)
      description            = try(egress_rules.value.description, null)
      ip_version             = try(egress_rules.value.ip_version, 4)
      source_ip_address      = try(egress_rules.value.source_ip_address, null)
      source_port            = try(egress_rules.value.source_port, null)
      destination_ip_address = try(egress_rules.value.destination_ip_address, null)
      destination_port       = try(egress_rules.value.destination_port, null)
    }
  }

  dynamic "associated_subnets" {
    for_each = huaweicloud_vpc_subnet.intra[*].id
    content {
      subnet_id = associated_subnets.value
    }
  }

  tags = merge(
    { "Name" = "${var.name}-${var.intra_subnet_suffix}" },
    var.tags,
    var.intra_acl_tags,
  )
}

################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
  nat_gateway_ips   = var.reuse_nat_ips ? var.external_nat_ip_ids : try(huaweicloud_vpc_eip.nat[*].id, [])
}

resource "huaweicloud_vpc_eip" "nat" {
  count = local.create_vpc && var.enable_nat_gateway && !var.reuse_nat_ips ? local.nat_gateway_count : 0

  region = var.region

  name = format("${var.name}-%s", element(var.azs, var.single_nat_gateway ? 0 : count.index))

  enterprise_project_id = var.enterprise_project_id

  publicip {
    type = var.nat_eip_publicip_type
  }

  bandwidth {
    share_type = "PER"
    name = coalesce(
      var.nat_eip_bandwidth_name,
      format("${var.name}-%s", element(var.azs, var.single_nat_gateway ? 0 : count.index))
    )
    size        = var.nat_eip_bandwidth_size
    charge_mode = var.nat_eip_bandwidth_charge_mode
  }

  tags = merge(
    {
      Name = format("${var.name}-%s", element(var.azs, var.single_nat_gateway ? 0 : count.index))
    },
    var.tags,
    var.nat_eip_tags,
  )

  timeouts {
    create = "10m"
    update = "5m"
    delete = "5m"
  }
}

resource "huaweicloud_nat_gateway" "this" {
  count = local.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  name                  = format("${var.name}-%s", element(var.azs, var.single_nat_gateway ? 0 : count.index))
  spec                  = "1"
  vpc_id                = local.vpc_id
  subnet_id             = element(huaweicloud_vpc_subnet.public[*].id, var.single_nat_gateway ? 0 : count.index)
  enterprise_project_id = var.enterprise_project_id

  tags = merge(
    {
      "Name" = format("${var.name}-%s", element(var.azs, var.single_nat_gateway ? 0 : count.index))
    },
    var.tags,
    var.nat_gateway_tags,
  )

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

resource "huaweicloud_vpc_route" "private_nat_gateway" {
  count = local.create_vpc && var.enable_nat_gateway && var.create_private_nat_gateway_route ? local.nat_gateway_count : 0

  region = var.region

  vpc_id         = local.vpc_id
  destination    = var.nat_gateway_destination_cidr_block
  type           = "nat"
  nexthop        = element(huaweicloud_nat_gateway.this[*].id, count.index)
  route_table_id = element(huaweicloud_vpc_route_table.private[*].id, count.index)

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "huaweicloud_nat_snat_rule" "private" {
  count = local.create_vpc && var.enable_nat_gateway && local.create_private_subnets ? local.len_private_subnets : 0

  region = var.region

  nat_gateway_id = element(huaweicloud_nat_gateway.this[*].id, var.single_nat_gateway ? 0 : count.index)
  floating_ip_id = element(local.nat_gateway_ips, var.single_nat_gateway ? 0 : count.index)
  subnet_id      = element(huaweicloud_vpc_subnet.private[*].id, count.index)
  source_type    = var.nat_snat_rule_source_type

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

################################################################################
# Default Network ACL
################################################################################

resource "huaweicloud_vpc_network_acl" "default" {
  count = local.create_vpc && var.manage_default_network_acl ? 1 : 0

  region                = var.region
  name                  = "${var.name}-default"
  enterprise_project_id = var.enterprise_project_id
  enabled               = true

  dynamic "ingress_rules" {
    for_each = var.default_network_acl_ingress
    content {
      action                 = ingress_rules.value.action
      protocol               = ingress_rules.value.protocol
      name                   = try(ingress_rules.value.name, null)
      description            = try(ingress_rules.value.description, null)
      ip_version             = try(ingress_rules.value.ip_version, 4)
      source_ip_address      = try(ingress_rules.value.source_ip_address, null)
      source_port            = try(ingress_rules.value.source_port, null)
      destination_ip_address = try(ingress_rules.value.destination_ip_address, null)
      destination_port       = try(ingress_rules.value.destination_port, null)
    }
  }

  dynamic "egress_rules" {
    for_each = var.default_network_acl_egress
    content {
      action                 = egress_rules.value.action
      protocol               = egress_rules.value.protocol
      name                   = try(egress_rules.value.name, null)
      description            = try(egress_rules.value.description, null)
      ip_version             = try(egress_rules.value.ip_version, 4)
      source_ip_address      = try(egress_rules.value.source_ip_address, null)
      source_port            = try(egress_rules.value.source_port, null)
      destination_ip_address = try(egress_rules.value.destination_ip_address, null)
      destination_port       = try(egress_rules.value.destination_port, null)
    }
  }

  tags = merge(
    { "Name" = "${var.name}-default" },
    var.tags,
    var.default_network_acl_tags,
  )
}

################################################################################
# VPC Flow Log
################################################################################

locals {
  # Only create flow log if VPC is created and flow log is enabled
  create_flow_log = local.create_vpc && var.enable_flow_log

  flow_log_name = var.flow_log_name != null ? var.flow_log_name : "${var.name}-flow-log"

  # Determine resource_id: use provided value, or default to VPC ID for vpc type
  flow_log_resource_id = var.flow_log_resource_id != null ? var.flow_log_resource_id : (
    var.flow_log_resource_type == "vpc" ? local.vpc_id : ""
  )
}

module "vpc_flow_log" {
  source = "./modules/flow-log"

  count = local.create_flow_log ? 1 : 0

  region = var.region

  name          = local.flow_log_name
  resource_type = var.flow_log_resource_type
  resource_id   = local.flow_log_resource_id
  traffic_type  = var.flow_log_traffic_type
  enabled       = var.flow_log_enabled

  # LTS configuration
  create_lts_resources  = var.flow_log_create_lts_resources
  log_group_id          = var.flow_log_log_group_id
  log_stream_id         = var.flow_log_log_stream_id
  lts_group_name        = var.flow_log_lts_group_name
  lts_group_ttl_in_days = var.flow_log_lts_group_ttl_in_days
  lts_stream_name       = var.flow_log_lts_stream_name

  tags            = var.tags
  lts_group_tags  = var.flow_log_lts_group_tags
  lts_stream_tags = var.flow_log_lts_stream_tags
}

################################################################################
# Private Subnet Flow Logs
################################################################################

module "private_subnet_flow_logs" {
  source = "./modules/flow-log"

  for_each = local.create_private_subnets && var.enable_private_subnet_flow_logs ? { for idx, subnet in var.private_subnets : idx => subnet } : {}

  region = var.region

  name          = try(var.private_subnet_flow_log_name_override[each.key], "${var.name}-${var.private_subnet_suffix}-${each.key}-flowlog")
  resource_type = "network"
  resource_id   = huaweicloud_vpc_subnet.private[each.key].id
  traffic_type  = var.private_subnet_flow_log_traffic_type
  enabled       = var.private_subnet_flow_log_enabled

  # LTS Resources - automatic creation
  create_lts_resources  = var.private_subnet_flow_log_create_lts_resources
  lts_group_name        = var.private_subnet_flow_log_lts_group_name
  lts_group_ttl_in_days = var.private_subnet_flow_log_lts_group_ttl_in_days
  lts_stream_name       = var.private_subnet_flow_log_lts_stream_name

  # If user provides external LTS resources
  log_group_id  = var.private_subnet_flow_log_log_group_id
  log_stream_id = var.private_subnet_flow_log_log_stream_id

  # Tags for LTS resources only (flow log doesn't support tags)
  tags            = var.tags
  lts_group_tags  = var.private_subnet_flow_log_tags
  lts_stream_tags = var.private_subnet_flow_log_tags
}

################################################################################
# Public Subnet Flow Logs
################################################################################

module "public_subnet_flow_logs" {
  source = "./modules/flow-log"

  for_each = local.create_public_subnets && var.enable_public_subnet_flow_logs ? { for idx, subnet in var.public_subnets : idx => subnet } : {}

  region = var.region

  name          = try(var.public_subnet_flow_log_name_override[each.key], "${var.name}-${var.public_subnet_suffix}-${each.key}-flowlog")
  resource_type = "network"
  resource_id   = huaweicloud_vpc_subnet.public[each.key].id
  traffic_type  = var.public_subnet_flow_log_traffic_type
  enabled       = var.public_subnet_flow_log_enabled

  # LTS Resources - automatic creation
  create_lts_resources  = var.public_subnet_flow_log_create_lts_resources
  lts_group_name        = var.public_subnet_flow_log_lts_group_name
  lts_group_ttl_in_days = var.public_subnet_flow_log_lts_group_ttl_in_days
  lts_stream_name       = var.public_subnet_flow_log_lts_stream_name

  # If user provides external LTS resources
  log_group_id  = var.public_subnet_flow_log_log_group_id
  log_stream_id = var.public_subnet_flow_log_log_stream_id

  # Tags for LTS resources only (flow log doesn't support tags)
  tags            = var.tags
  lts_group_tags  = var.public_subnet_flow_log_tags
  lts_stream_tags = var.public_subnet_flow_log_tags
}

################################################################################
# Database Subnet Flow Logs
################################################################################

module "database_subnet_flow_logs" {
  source = "./modules/flow-log"

  for_each = local.create_database_subnets && var.enable_database_subnet_flow_logs ? { for idx, subnet in var.database_subnets : idx => subnet } : {}

  region = var.region

  name          = try(var.database_subnet_flow_log_name_override[each.key], "${var.name}-${var.database_subnet_suffix}-${each.key}-flowlog")
  resource_type = "network"
  resource_id   = huaweicloud_vpc_subnet.database[each.key].id
  traffic_type  = var.database_subnet_flow_log_traffic_type
  enabled       = var.database_subnet_flow_log_enabled

  # LTS Resources - automatic creation
  create_lts_resources  = var.database_subnet_flow_log_create_lts_resources
  lts_group_name        = var.database_subnet_flow_log_lts_group_name
  lts_group_ttl_in_days = var.database_subnet_flow_log_lts_group_ttl_in_days
  lts_stream_name       = var.database_subnet_flow_log_lts_stream_name

  # If user provides external LTS resources
  log_group_id  = var.database_subnet_flow_log_log_group_id
  log_stream_id = var.database_subnet_flow_log_log_stream_id

  # Tags for LTS resources only (flow log doesn't support tags)
  tags            = var.tags
  lts_group_tags  = var.database_subnet_flow_log_tags
  lts_stream_tags = var.database_subnet_flow_log_tags
}

################################################################################
# Address Groups
################################################################################

resource "huaweicloud_vpc_address_group" "this" {
  for_each = var.address_groups

  region = var.region

  name                  = coalesce(try(each.value.name, null), each.key)
  ip_version            = try(each.value.ip_version, 4)
  addresses             = try(each.value.addresses, null)
  description           = try(each.value.description, null)
  max_capacity          = try(each.value.max_capacity, null)
  enterprise_project_id = try(each.value.enterprise_project_id, var.enterprise_project_id)
  force_destroy         = try(each.value.force_destroy, false)

  dynamic "ip_extra_set" {
    for_each = each.value.ip_extra_set
    content {
      ip      = ip_extra_set.value.ip
      remarks = try(ip_extra_set.value.remarks, null)
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}