provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  vpc_cidr = "10.0.0.0/16"

  azs = slice(data.huaweicloud_availability_zones.available.names, 0, 2)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-huawei-vpc"
    GithubOrg  = "terraform-huawei-modules"
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
  intra_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 12)]

  create_database_subnet_route_table    = true
  create_multiple_database_route_tables = false
  create_multiple_intra_route_tables    = false

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

