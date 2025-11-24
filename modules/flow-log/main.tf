locals {
  create_lts_resources = var.create && var.create_lts_resources

  log_group_id  = local.create_lts_resources ? huaweicloud_lts_group.this[0].id : var.log_group_id
  log_stream_id = local.create_lts_resources ? huaweicloud_lts_stream.this[0].id : var.log_stream_id

  lts_group_name  = var.lts_group_name != null ? var.lts_group_name : "${var.name}-group"
  lts_stream_name = var.lts_stream_name != null ? var.lts_stream_name : "${var.name}-stream"
}

################################################################################
# LTS Log Group
################################################################################

resource "huaweicloud_lts_group" "this" {
  count = local.create_lts_resources ? 1 : 0

  region = var.region

  group_name  = local.lts_group_name
  ttl_in_days = var.lts_group_ttl_in_days

  tags = merge(
    var.tags,
    var.lts_group_tags,
  )
}

################################################################################
# LTS Log Stream
################################################################################

resource "huaweicloud_lts_stream" "this" {
  count = local.create_lts_resources ? 1 : 0

  region = var.region

  group_id    = huaweicloud_lts_group.this[0].id
  stream_name = local.lts_stream_name

  tags = merge(
    var.tags,
    var.lts_stream_tags,
  )
}

################################################################################
# VPC Flow Log
################################################################################

resource "huaweicloud_vpc_flow_log" "this" {
  count = var.create ? 1 : 0

  region = var.region

  name          = var.name
  resource_type = var.resource_type
  resource_id   = var.resource_id
  traffic_type  = var.traffic_type
  log_group_id  = local.log_group_id
  log_stream_id = local.log_stream_id
  enabled       = var.enabled
}
