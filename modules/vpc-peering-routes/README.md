# VPC Peering Routes

This module manages VPC peering routes in one or both directions between two VPCs. It does not create the peering connection; it expects a peering connection ID and writes routes to the provided route tables.

## Usage

```hcl
module "vpc_peering_routes" {
  source = "../../modules/vpc-peering-routes"

  a_vpc_id              = module.vpc_a.vpc_id
  b_vpc_id              = module.vpc_b.vpc_id
  peering_connection_id = module.vpc_a.vpc_peering_ids["peer-to-b"]

  a_route_table_ids        = module.vpc_a.private_route_table_ids
  b_route_table_ids        = module.vpc_b.private_route_table_ids

  a_to_b_destination_cidrs = [module.vpc_b.vpc_cidr_block]
  b_to_a_destination_cidrs = [module.vpc_a.vpc_cidr_block]

  enable_routes_a_to_b = true
  enable_routes_b_to_a = true
}
```

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

No modules.

## Resources

| Name | Type |
|------|------|
| huaweicloud_vpc_route.a_to_b | resource |
| huaweicloud_vpc_route.b_to_a | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| a_vpc_id | ID of VPC A (requester side). | string | n/a | yes |
| b_vpc_id | ID of VPC B (accepter side). | string | n/a | yes |
| peering_connection_id | ID of the VPC peering connection used as next hop. | string | n/a | yes |
| a_route_table_ids | Route table IDs to update in VPC A. | list(string) | [] | no |
| b_route_table_ids | Route table IDs to update in VPC B. | list(string) | [] | no |
| a_to_b_destination_cidrs | Destination CIDRs in VPC B reachable from VPC A. | list(string) | [] | no |
| b_to_a_destination_cidrs | Destination CIDRs in VPC A reachable from VPC B. | list(string) | [] | no |
| enable_routes_a_to_b | Whether to create routes in VPC A toward destinations in VPC B. | bool | true | no |
| enable_routes_b_to_a | Whether to create routes in VPC B toward destinations in VPC A. | bool | true | no |

## Outputs

| Name | Description |
|------|-------------|
| a_to_b_route_ids | IDs of routes created in VPC A toward destinations in VPC B. |
| b_to_a_route_ids | IDs of routes created in VPC B toward destinations in VPC A. |

## Notes

- Same-tenant peering typically requires no explicit accept step; the peering connection ID can be used directly as the next hop.
- For cross-tenant peering, manage requester with `huaweicloud_vpc_peering_connection` and accepter with `huaweicloud_vpc_peering_connection_accepter`.


