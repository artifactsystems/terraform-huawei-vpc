provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, 2)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-huawei-vpc"
    GithubOrg  = "terraform-huawei-modules"
  }

  # HuaweiCloud Network ACL rules (different structure than AWS)
  network_acls = {
    # Default rules for ephemeral ports (return traffic)
    default_inbound = [
      {
        action            = "allow"
        ip_version        = 4
        protocol          = "tcp"
        source_ip_address = "0.0.0.0/0"
        destination_port  = "1024-65535"
        description       = "Allow ephemeral ports inbound"
      },
    ]
    default_outbound = [
      {
        action                 = "allow"
        ip_version             = 4
        protocol               = "tcp"
        destination_ip_address = "0.0.0.0/0"
        destination_port       = "32768-65535"
        description            = "Allow ephemeral ports outbound"
      },
    ]
    public_inbound = [
      {
        action            = "allow"
        ip_version        = 4
        protocol          = "tcp"
        source_ip_address = "0.0.0.0/0"
        destination_port  = "80"
        description       = "Allow HTTP from anywhere"
      },
      {
        action            = "allow"
        ip_version        = 4
        protocol          = "tcp"
        source_ip_address = "0.0.0.0/0"
        destination_port  = "443"
        description       = "Allow HTTPS from anywhere"
      },
      {
        action            = "allow"
        ip_version        = 4
        protocol          = "tcp"
        source_ip_address = "0.0.0.0/0"
        destination_port  = "22"
        description       = "Allow SSH from anywhere"
      },
    ]
    public_outbound = [
      {
        action                 = "allow"
        ip_version             = 4
        protocol               = "tcp"
        destination_ip_address = "0.0.0.0/0"
        destination_port       = "80,443"
        description            = "Allow HTTP/HTTPS outbound"
      },
      {
        action                 = "allow"
        ip_version             = 4
        protocol               = "tcp"
        destination_ip_address = "10.0.0.0/16"
        destination_port       = "1433"
        description            = "Allow DB access to private subnet"
      },
      {
        action                 = "allow"
        ip_version             = 4
        protocol               = "icmp"
        destination_ip_address = "10.0.0.0/22"
        description            = "Allow ICMP to local subnet"
      },
    ]
    private_inbound = [
      {
        action            = "allow"
        ip_version        = 4
        protocol          = "tcp"
        source_ip_address = "10.0.0.0/16"
        description       = "Allow traffic from VPC"
      },
    ]
    private_outbound = [
      {
        action                 = "allow"
        ip_version             = 4
        protocol               = "tcp"
        destination_ip_address = "0.0.0.0/0"
        description            = "Allow all outbound traffic"
      },
    ]
    database_inbound = [
      {
        action            = "allow"
        ip_version        = 4
        protocol          = "tcp"
        source_ip_address = "10.0.0.0/16"
        destination_port  = "5432,3306"
        description       = "Allow DB access from VPC"
      },
    ]
    database_outbound = [
      {
        action                 = "allow"
        ip_version             = 4
        protocol               = "tcp"
        destination_ip_address = "10.0.0.0/16"
        destination_port       = "5432,3306"
        description            = "Allow DB traffic to VPC"
      },
    ]
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../"

  name   = local.name
  region = local.region
  cidr   = local.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

  # Network ACLs - using concat to combine default and specific rules
  public_dedicated_network_acl = true
  public_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["public_inbound"])
  public_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["public_outbound"])
  database_outbound_acl_rules  = concat(local.network_acls["default_outbound"], local.network_acls["database_outbound"])

  private_dedicated_network_acl  = false
  database_dedicated_network_acl = true

  manage_default_network_acl = true

  enable_nat_gateway = false
  single_nat_gateway = true


  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = local.tags

  vpc_tags = {
    Name = "vpc-name"
  }
}