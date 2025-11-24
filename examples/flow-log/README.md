# VPC Example with VPC Flow Logs (LTS)

This directory enables Huawei Cloud LTS (Log Tank Service)–based VPC Flow Logs for the VPC and subnets (public/private/database). The example creates flow logs with different traffic types and retention (TTL) per subnet type.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Note: This example may create billable resources (e.g., NAT Gateway/EIP and LTS usage). Run `terraform destroy` when you no longer need these resources.

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
| vpc_complete_flow_logs | ../../ | n/a |
| disabled | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| huaweicloud_availability_zones.available | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| vpc_flow_log_id | VPC-level flow log ID |
| vpc_flow_log_lts_group_id | LTS group ID created for the VPC flow log |
| vpc_flow_log_lts_stream_id | LTS stream ID created for the VPC flow log |
| private_subnet_flow_log_ids | Map of private subnet IDs to their flow log IDs |
| private_subnet_flow_log_lts_group_ids | Map of private subnet IDs to their LTS group IDs |
| public_subnet_flow_log_ids | Map of public subnet IDs to their flow log IDs |
| public_subnet_flow_log_lts_group_ids | Map of public subnet IDs to their LTS group IDs |
| database_subnet_flow_log_ids | Map of database subnet IDs to their flow log IDs |
| database_subnet_flow_log_lts_group_ids | Map of database subnet IDs to their LTS group IDs |


