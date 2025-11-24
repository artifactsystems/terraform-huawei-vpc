# HuaweiCloud VPC Terraform Module

Terraform module which creates VPC resources on HuaweiCloud.

## Usage

```hcl
module "vpc" {
  source = "../.." # Adjust for your usage; see ./examples/* for references

  name   = "my-vpc"
  region = "tr-west-1"
  cidr   = "10.0.0.0/16"

  azs             = ["tr-west-1a", "tr-west-1b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Features

This module supports the following VPC features:

- ✅ **VPC and Subnets**: Create VPC with public, private, database, and intra subnets across multiple Availability Zones
- ✅ **NAT Gateway**: Internet access for private subnets via NAT Gateway with SNAT rules
- ✅ **Route Tables**: Separate route tables per subnet type with flexible configuration
- ✅ **Network ACLs**: Stateless firewall rules for subnet-level traffic control
- ✅ **Secondary CIDR Blocks**: Expand VPC address space with up to 5 additional CIDR blocks
- ✅ **IPv6 Support**: Dual-stack (IPv4 + IPv6) configuration for subnets
- ✅ **Multi-AZ High Availability**: Distribute resources across Availability Zones for fault tolerance
- ✅ **Flexible NAT Options**: Single NAT, one per AZ, or custom scenarios
- ✅ **DNS and DHCP Configuration**: Custom DNS servers and DHCP options per subnet
- ✅ **Tag Management**: Comprehensive tagging support for all resources
- ✅ **Enterprise Project Integration**: Support for HuaweiCloud Enterprise Projects
- ✅ **VPC Flow Logs**: VPC and subnet-level flow logs with LTS (Log Tank Service)
- ✅ **VPC Peering**: Create VPC peering connections and optionally add peering routes

## Examples

- [simple](./examples/simple) - Simple VPC with public/private subnets and NAT Gateway
- [complete](./examples/complete) - Complete VPC with all features (multi-AZ, secondary CIDR, Network ACL)
- [separate-route-tables](./examples/separate-route-tables) - Separate route tables per subnet type
- [network-acls](./examples/network-acls) - Network ACL rules for subnet-level security
- [secondary-cidr-blocks](./examples/secondary-cidr-blocks) - VPC with secondary CIDR blocks
- [flow-log](./examples/flow-log) - VPC and subnet-level flow logs with LTS integration
- [vpc-peering](./examples/vpc-peering) - VPC peering with optional route creation

## NAT Gateway Scenarios

The module supports three scenarios for creating NAT Gateways:

- One NAT Gateway per subnet (default)
  - `enable_nat_gateway = true`
  - `single_nat_gateway = false`
  - `one_nat_gateway_per_az = false`
- Single (shared) NAT Gateway
  - `enable_nat_gateway = true`
  - `single_nat_gateway = true`
  - `one_nat_gateway_per_az = false`
- One NAT Gateway per Availability Zone
  - `enable_nat_gateway = true`
  - `single_nat_gateway = false`
  - `one_nat_gateway_per_az = true`

If both `single_nat_gateway` and `one_nat_gateway_per_az` are `true`, `single_nat_gateway` takes precedence.

Requirements:
- When `one_nat_gateway_per_az = true`, `var.azs` must be specified.
- The number of `public_subnets` must be greater than or equal to the number of `var.azs`.

### Default: One NAT per subnet

By default, the module determines the number of NAT Gateways based on the lengths of private subnet lists (e.g., `private_subnets`, `database_subnets`).

### Single NAT Gateway

When `single_nat_gateway = true`, all private subnets route Internet traffic through a single NAT (typically placed in the first public subnet).

### One NAT per AZ

When `one_nat_gateway_per_az = true`, a NAT is placed in each AZ; ensure `azs` and public subnet counts are aligned.

## "private" vs "intra" subnets

With NAT enabled, `private_subnets` route Internet traffic via NAT. For purely internal networking with no Internet routes, use `intra_subnets`.

Example use case: workloads needing access only to internal services or via VPC endpoints.

## Conditional creation

Prior to Terraform 0.13, `count` could not be used in module blocks. To toggle resource creation, use `create_vpc`:

```hcl
module "vpc" {
  source     = "../.."
  create_vpc = false
}
```

