# Simple VPC with Secondary CIDR Blocks

This directory creates VPC resources spread across multiple CIDR blocks.

For each Availability Zone (AZ), one public and one private subnet are created. NAT Gateway is disabled in this scenario. Secondary CIDR blocks are used to scale private subnets.

## Usage

To run this example:

```bash
terraform init
terraform plan
terraform apply
```

Note: This example may create billable resources (e.g., EIP). Run `terraform destroy` when you no longer need these resources.

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
| vpc_secondary_cidr_blocks | List of secondary CIDR blocks of the VPC |
| private_subnets | List of IDs of private subnets |
| private_subnets_cidr_blocks | List of CIDR blocks of private subnets |
| public_subnets | List of IDs of public subnets |
| public_subnets_cidr_blocks | List of CIDR blocks of public subnets |
