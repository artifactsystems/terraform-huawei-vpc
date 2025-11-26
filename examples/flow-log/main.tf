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
}

################################################################################
# VPC with Complete Flow Log Coverage
################################################################################

module "vpc_complete_flow_logs" {
  source = "../../"

  name = "${local.name}-complete"
  cidr = local.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_flow_log       = true
  flow_log_traffic_type = "all"

  enable_private_subnet_flow_logs               = true
  private_subnet_flow_log_traffic_type          = "all"
  private_subnet_flow_log_lts_group_ttl_in_days = 30

  enable_public_subnet_flow_logs               = true
  public_subnet_flow_log_traffic_type          = "reject"
  public_subnet_flow_log_lts_group_ttl_in_days = 14

  enable_database_subnet_flow_logs               = true
  database_subnet_flow_log_traffic_type          = "all"
  database_subnet_flow_log_lts_group_ttl_in_days = 90

  tags = local.tags
}

module "disabled" {
  source = "../../"

  create_vpc = false
}
