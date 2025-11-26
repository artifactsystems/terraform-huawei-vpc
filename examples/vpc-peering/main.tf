provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  # VPC CIDRs
  vpc_a_cidr = "10.20.0.0/16"
  vpc_b_cidr = "172.16.0.0/16"

  # Pick first two AZs
  azs = slice(data.huaweicloud_availability_zones.available.names, 0, 2)

  # Subnets
  vpc_a_private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_a_cidr, 8, k)]

  vpc_b_private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_b_cidr, 8, k)]

  # Peering routes (A -> B, B -> A)
  vpc_b_destination_cidrs = [local.vpc_b_cidr]
  vpc_a_destination_cidrs = [local.vpc_a_cidr]
}

################################################################################
# VPC A (Requester)
################################################################################

module "vpc_a" {
  source = "../.."

  name   = "${local.name}-a"
  region = local.region
  cidr   = local.vpc_a_cidr

  azs             = local.azs
  public_subnets  = []
  private_subnets = local.vpc_a_private_subnets

  enable_vpc_peering = true
  vpc_peerings = {
    peer-to-b = {
      peer_vpc_id = module.vpc_b.vpc_id
      description = "Peering from A to B"
    }
  }
}

################################################################################
# VPC B (Accepter)
################################################################################

module "vpc_b" {
  source = "../.."

  name   = "${local.name}-b"
  region = local.region
  cidr   = local.vpc_b_cidr

  azs             = local.azs
  public_subnets  = []
  private_subnets = local.vpc_b_private_subnets
}

################################################################################
# Peering routes via wrapper (configurable one- or bi-directional)
################################################################################

module "vpc_peering_routes" {
  source = "../../modules/vpc-peering-routes"

  a_vpc_id              = module.vpc_a.vpc_id
  b_vpc_id              = module.vpc_b.vpc_id
  peering_connection_id = module.vpc_a.vpc_peering_ids["peer-to-b"]

  a_route_table_ids = module.vpc_a.private_route_table_ids
  b_route_table_ids = module.vpc_b.private_route_table_ids

  a_to_b_destination_cidrs = local.vpc_b_destination_cidrs
  b_to_a_destination_cidrs = local.vpc_a_destination_cidrs

  enable_routes_a_to_b = true
  enable_routes_b_to_a = true
}
