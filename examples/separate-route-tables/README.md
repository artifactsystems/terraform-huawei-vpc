# VPC with Separate Private Route Tables

This directory contains VPC resources suitable for staging or production environments (for a simpler setup, see `../simple`).

For each Availability Zone (AZ), public, private, database, and intra subnets are created. A NAT Gateway is provided per AZ. This example configures separate private route tables for the database and intra subnets.

## Usage

To run this example:

```bash
terraform init
terraform plan
terraform apply
```

Note: This example may create billable resources (e.g., NAT Gateway/EIP). Run `terraform destroy` when you no longer need these resources.

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
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnets | List of IDs of public subnets |
| public_subnets_cidr_blocks | List of CIDR blocks of public subnets |
| public_route_table_ids | List of IDs of public route tables |
| private_subnets | List of IDs of private subnets |
| private_subnets_cidr_blocks | List of CIDR blocks of private subnets |
| private_route_table_ids | List of IDs of private route tables |
| database_subnets | List of IDs of database subnets |
| database_subnets_cidr_blocks | List of CIDR blocks of database subnets |
| database_route_table_ids | List of IDs of database route tables |
| intra_subnets | List of IDs of intra subnets |
| intra_subnets_cidr_blocks | List of CIDR blocks of intra subnets |
| intra_route_table_ids | List of IDs of intra route tables |
| nat_ids | List of allocation IDs of EIPs created for NAT Gateway |
| natgw_ids | List of NAT Gateway IDs |


