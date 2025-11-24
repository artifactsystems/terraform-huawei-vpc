# Simple VPC with Address Groups

This directory demonstrates defining one or more Address Groups while creating a VPC. It includes IPv4 and IPv6 examples using single IP, range, and CIDR formats, as well as usage of `ip_extra_set`, `description`, and `max_capacity` fields.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Note: This example may create billable resources. Run `terraform destroy` when you no longer need them.

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
| (no data sources used) | - |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| address_group_ids | Map of created Address Group IDs |


