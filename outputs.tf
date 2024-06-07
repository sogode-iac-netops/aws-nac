# Outputs

#
# Stage 1

#
# ew1_hub VPC outputs
output "ew1_hub_vpc_id" {
  value = module.ew1_hub.vpc_id
}

output "ew1_hub_vpc_cidr" {
  value = module.ew1_hub.vpc_cidr
}

output "ew1_hub_main_route_table_id" {
  value = module.ew1_hub.main_route_table_id
}

output "ew1_hub_default_route_table_id" {
  value = module.ew1_hub.default_route_table_id
}

output "ew1_hub_default_network_acl_id" {
  value = module.ew1_hub.default_network_acl_id
}

output "ew1_hub_default_security_group_id" {
  value = module.ew1_hub.default_security_group_id
}

output "ew1_hub_subnets" {
  value = {
    for idx, subnet in module.ew1_hub.subnets : idx => {
      id                = subnet.id
      cidr_block        = subnet.cidr_block
      vpc_id            = subnet.vpc_id
      availability_zone = subnet.availability_zone
      description       = subnet.description
      ipam_id           = subnet.ipam_id
      scope             = subnet.scope
    }
  }
}

#
# ue2_hub VPC outputs
output "ue2_hub_vpc_id" {
  value = module.ue2_hub.vpc_id
}

output "ue2_hub_vpc_cidr" {
  value = module.ue2_hub.vpc_cidr
}

output "ue2_hub_main_route_table_id" {
  value = module.ue2_hub.main_route_table_id
}

output "ue2_hub_default_route_table_id" {
  value = module.ue2_hub.default_route_table_id
}

output "ue2_hub_default_network_acl_id" {
  value = module.ue2_hub.default_network_acl_id
}

output "ue2_hub_default_security_group_id" {
  value = module.ue2_hub.default_security_group_id
}

output "ue2_hub_subnets" {
  value = {
    for idx, subnet in module.ue2_hub.subnets : idx => {
      id                = subnet.id
      cidr_block        = subnet.cidr_block
      vpc_id            = subnet.vpc_id
      availability_zone = subnet.availability_zone
      description       = subnet.description
      ipam_id           = subnet.ipam_id
      scope             = subnet.scope
    }
  }
}

#
# ew1_internet output
output "ew1_internet_gateway_id" {
  value = module.ew1_internet.internet_gateway_id
}

output "ew1_rt_local_internet_id" {
  value = module.ew1_internet.rt_local_internet_id
}

#
# ue2_internet output
output "ue2_internet_gateway_id" {
  value = module.ue2_internet.internet_gateway_id
}

output "ue2_rt_local_internet_id" {
  value = module.ue2_internet.rt_local_internet_id
}

#
# ew1_tgw outputs
output "ew1_tgw_id" {
  value = module.ew1_tgw.tgw_id
}

output "ew1_tgw_association_default_route_table_id" {
  value = module.ew1_tgw.tgw_association_default_route_table_id
}

output "ew1_tgw_propagation_default_route_table_id" {
  value = module.ew1_tgw.tgw_propagation_default_route_table_id
}

output "ew1_tga_base_vpc_attachment_id" {
  value = module.ew1_tgw.tga_base_vpc_attachment_id
}

output "ew1_r_base_10_id" {
  value = module.ew1_tgw.r_base_10_id
}

output "ew1_r_base_id" {
  value = module.ew1_tgw.r_base_id
}

output "ew1_r_ipv4_default_id" {
  value = module.ew1_tgw.r_ipv4_default_id
}

#
# ue2_tgw outputs
output "ue2_tgw_id" {
  value = module.ue2_tgw.tgw_id
}

output "ue2_tgw_association_default_route_table_id" {
  value = module.ue2_tgw.tgw_association_default_route_table_id
}

output "ue2_tgw_propagation_default_route_table_id" {
  value = module.ue2_tgw.tgw_propagation_default_route_table_id
}

output "ue2_tga_base_vpc_attachment_id" {
  value = module.ue2_tgw.tga_base_vpc_attachment_id
}

output "ue2_r_base_10_id" {
  value = module.ue2_tgw.r_base_10_id
}

output "ue2_r_base_id" {
  value = module.ue2_tgw.r_base_id
}

output "ue2_r_ipv4_default_id" {
  value = module.ue2_tgw.r_ipv4_default_id
}

#
# Stage 2

#
# bb_ew1 outputs
output "ew1_bb_routes" {
  value = {
    for idx, route in module.ew1_bb.routes : idx => {
      id                     = route.id
      destination_cidr_block = route.destination_cidr_block
    }
  }
}

#
# bb_ue2 outputs
output "ue2_bb_routes" {
  value = {
    for idx, route in module.ue2_bb.routes : idx => {
      id                     = route.id
      destination_cidr_block = route.destination_cidr_block
    }
  }
}

/*
#
# Stage 3


# ew1_spoke_foov1 outputs
output "ew1_spoke_foov1_vpc_id" {
  value = module.ew1_spoke_foov1.vpc_id
}

output "ew1_spoke_foov1_vpc_cidr" {
  value = module.ew1_spoke_foov1.vpc_cidr
}

output "ew1_spoke_foov1_main_route_table_id" {
  value = module.ew1_spoke_foov1.main_route_table_id
}

output "ew1_spoke_foov1_default_route_table_id" {
  value = module.ew1_spoke_foov1.default_route_table_id
}

output "ew1_spoke_foov1_default_network_acl_id" {
  value = module.ew1_spoke_foov1.default_network_acl_id
}

output "ew1_spoke_foov1_default_security_group_id" {
  value = module.ew1_spoke_foov1.default_security_group_id
}

output "ew1_spoke_foov1_subnets" {
  value = {
    for idx, subnet in module.ew1_spoke_foov1.subnets : idx => {
      id                = subnet.id
      cidr_block        = subnet.cidr_block
      vpc_id            = subnet.vpc_id
      availability_zone = subnet.availability_zone
      description       = subnet.description
      ipam_id           = subnet.ipam_id
      scope             = subnet.scope
    }
  }
}

# output "ew1_spoke_foov1_tga_id" {
#   value = module.ew1_spoke_foov1.tga_id
# }
# 
# output "ew1_spoke_foov1_r_id" {
#   value = module.ew1_spoke_foov1.r_id
# }
# 
*/
