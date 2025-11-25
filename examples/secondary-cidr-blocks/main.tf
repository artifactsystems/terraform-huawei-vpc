provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  vpc_cidr              = "10.0.0.0/16"
  secondary_cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]
  azs                   = slice(data.huaweicloud_availability_zones.available.names, 0, 2)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-huawei-vpc"
    GithubOrg  = "artifactsystems"
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

  secondary_cidr_blocks = local.secondary_cidr_blocks

  azs = local.azs
  private_subnets = concat(
    [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)],
    [for k, v in local.azs : cidrsubnet(element(local.secondary_cidr_blocks, 0), 2, k)],
    [for k, v in local.azs : cidrsubnet(element(local.secondary_cidr_blocks, 1), 2, k)],
  )
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = false

  tags = local.tags
}

