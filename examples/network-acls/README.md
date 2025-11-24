# Simple VPC with Network ACLs

This directory creates VPC resources along with Network ACLs for several subnets.

Inbound and outbound ACL rules are defined as follows:
1. Public subnets have dedicated ACL rules
2. Private subnets are associated with default ACL rules
3. Database subnets have dedicated ACL rules

## Usage

To run this example:

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
| vpc | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| huaweicloud_availability_zones.available | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| public_subnets | List of IDs of public subnets |
| private_subnets | List of IDs of private subnets |
| database_subnets | List of IDs of database subnets |
| public_network_acl_id | ID of the public network ACL |
| private_network_acl_id | ID of the private network ACL |
| database_network_acl_id | ID of the database network ACL |


