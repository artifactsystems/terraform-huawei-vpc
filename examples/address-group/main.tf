provider "huaweicloud" {
  region = local.region
}

locals {
  name     = "ex-${basename(path.cwd)}"
  region   = "tr-west-1"
  vpc_cidr = "10.0.0.0/16"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-huawei-vpc"
    GithubOrg  = "artifactsystems"
  }
}

module "vpc" {
  source = "../.."

  name   = local.name
  region = local.region
  cidr   = local.vpc_cidr

  tags = local.tags

  enable_nat_gateway         = false
  enable_flow_log            = false
  manage_default_network_acl = false

  address_groups = {
    group-ipv4 = {
      ip_version = 4
      addresses = [
        "192.168.10.10",
        "192.168.1.1-192.168.1.50"
      ]
    }

    group-ipv6 = {
      ip_version = 6
      addresses = [
        "2001:db8:a583:6e::/64"
      ]
    }

    group-ipv4-extra = {
      ip_version = 4
      ip_extra_set = [
        {
          ip      = "192.168.3.2"
          remarks = "terraform test 1"
        },
        {
          ip      = "192.168.5.0/24"
          remarks = "terraform test 2"
        },
        {
          ip = "192.168.3.20-192.168.3.100"
        }
      ]
      description  = "Example IPv4 group with ip_extra_set"
      max_capacity = 20
    }
  }
}


