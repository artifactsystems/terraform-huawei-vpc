resource "huaweicloud_vpc_route" "a_to_b" {
  for_each = var.enable_routes_a_to_b && length(var.a_route_table_ids) > 0 && length(var.a_to_b_destination_cidrs) > 0 ? {
    for combo in setproduct(
      toset([for i in range(length(var.a_route_table_ids)) : i]),
      var.a_to_b_destination_cidrs
      ) : join("|", [tostring(combo[0]), combo[1]]) => {
      route_table_index = combo[0]
      destination       = combo[1]
    }
  } : {}

  vpc_id         = var.a_vpc_id
  destination    = each.value.destination
  type           = "peering"
  nexthop        = var.peering_connection_id
  route_table_id = element(var.a_route_table_ids, each.value.route_table_index)
}

resource "huaweicloud_vpc_route" "b_to_a" {
  for_each = var.enable_routes_b_to_a && length(var.b_route_table_ids) > 0 && length(var.b_to_a_destination_cidrs) > 0 ? {
    for combo in setproduct(
      toset([for i in range(length(var.b_route_table_ids)) : i]),
      var.b_to_a_destination_cidrs
      ) : join("|", [tostring(combo[0]), combo[1]]) => {
      route_table_index = combo[0]
      destination       = combo[1]
    }
  } : {}

  vpc_id         = var.b_vpc_id
  destination    = each.value.destination
  type           = "peering"
  nexthop        = var.peering_connection_id
  route_table_id = element(var.b_route_table_ids, each.value.route_table_index)
}
