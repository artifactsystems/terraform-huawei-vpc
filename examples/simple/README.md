# Simple VPC

This directory contains a basic set of VPC resources that can be sufficient for a development environment.

For each Availability Zone (AZ), one public and one private subnet are created. A single NAT Gateway is shared across all AZs.

This example uses Availability Zone names and IDs via the `huaweicloud_availability_zones` data source for demonstration purposes. Normally, you only need to specify either names or IDs.

## Usage

To run this example, execute the following:

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
| vpc_status | The status of the VPC |
| name | The name of the VPC |
| azs | A list of availability zones specified as an argument to this module |
| public_subnets | List of IDs of public subnets |
| public_subnets_cidr_blocks | List of CIDR blocks of public subnets |
| public_subnet_gateway_ips | List of gateway IPs of public subnets |
| public_route_table_ids | List of IDs of public route tables |
| private_subnets | List of IDs of private subnets |
| private_subnets_cidr_blocks | List of CIDR blocks of private subnets |
| private_subnet_gateway_ips | List of gateway IPs of private subnets |
| private_route_table_ids | List of IDs of private route tables |
| nat_ids | List of allocation IDs of EIPs created for NAT Gateway |
| nat_public_ips | List of public EIPs created for NAT Gateway |
| natgw_ids | List of NAT Gateway IDs |


