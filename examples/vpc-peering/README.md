# VPC Peering

This directory contains an example that provisions two VPCs (A and B), creates a VPC Peering Connection from A to B, and configures peering routes using a small wrapper module.

## Usage

To run this example, execute the following:

```bash
terraform init
terraform plan
terraform apply
```

Note: This example may create billable resources. Run `terraform destroy` when you no longer need these resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| huaweicloud | >= 1.79.0 |

## Providers

| Name | Version |
|------|---------|
| huaweicloud | >= 1.79.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc_a | ../.. | n/a |
| vpc_b | ../.. | n/a |
| vpc_peering_routes | ../../modules/vpc-peering-routes | n/a |

## Resources

| Name | Type |
|------|------|
| huaweicloud_availability_zones.available | data source |

## How it works

- Each VPC is created via the root VPC module
- The peering connection is created via `enable_vpc_peering` + `vpc_peerings`
- Routes for both directions (A→B, B→A) are created by the `vpc-peering-routes` wrapper

## Notes

- Same-tenant peering: If both VPCs belong to the same tenant, the peering connection is created without an explicit accept step and can be used directly.
- Cross-tenant peering: Use `huaweicloud_vpc_peering_connection` for the requester and `huaweicloud_vpc_peering_connection_accepter` for the accepter.
