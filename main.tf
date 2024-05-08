#
# AWS Network As Code
# Multi-stage Terraform deployment including:
# - Regional Shared Service Hub VPC's with local internet access
# - Regional Transit Gateways, interconnecting into global backbone
# - Spoke VPCs per application, connected to local TGW
# - Contiguous routing between regions

#
# Stage 1
# - Regional hub VPCs
# - Regional Transit Gateways
# - Transit Gateways peering attachment requests (to be approved in web console)

#
# Read IPAM files with network information
locals {
  # Read ipam output file to create networks
  ipam_ew1_hub = jsondecode((file("${path.cwd}/ipam_hub_eu-west-1.json")))
  ipam_ue2_hub = jsondecode((file("${path.cwd}/ipam_hub_us-east-2.json")))
}

#
# Define the base VPCs
module "ew1_hub" {
  source = "./modules/base"
  providers = {
    aws = aws.ew1
  }

  cidr_block = local.ipam_ew1_hub.vpc_cidr
  vpc_name   = local.ipam_ew1_hub.vpc_description
  subnet_config = {
    for idx, subnet in local.ipam_ew1_hub.subnets :
    "subnet${idx + 1}" => {
      cidr              = subnet.cidr
      description       = subnet.description
      availability_zone = subnet.availability_zone
      ipam_id           = subnet.ipam_id
      scope             = subnet.scope
    }
  }
}

module "ue2_hub" {
  source = "./modules/base"
  providers = {
    aws = aws.ue2
  }

  cidr_block = local.ipam_ue2_hub.vpc_cidr
  vpc_name   = local.ipam_ue2_hub.vpc_description
  subnet_config = {
    for idx, subnet in local.ipam_ue2_hub.subnets :
    "subnet${idx + 1}" => {
      cidr              = subnet.cidr
      description       = subnet.description
      availability_zone = subnet.availability_zone
      ipam_id           = subnet.ipam_id
      scope             = subnet.scope
    }
  }
}

#
# Add internet connectivity
locals {
  ew1_public_subnet_ids = [
    for subnet in module.ew1_hub.subnets : subnet.id if subnet.scope == "public"
  ]
  ue2_public_subnet_ids = [
    for subnet in module.ue2_hub.subnets : subnet.id if subnet.scope == "public"
  ]
}

module "ew1_internet" {
  source = "./modules/internet"

  providers = {
    aws = aws.ew1
  }
  vpc_id     = module.ew1_hub.vpc_id
  subnet_ids = local.ew1_public_subnet_ids
}

module "ue2_internet" {
  source = "./modules/internet"

  providers = {
    aws = aws.ue2
  }
  vpc_id     = module.ue2_hub.vpc_id
  subnet_ids = local.ue2_public_subnet_ids
}

#
# Add transit gateways
locals {
  ew1_tgw_subnet_ids = [
    for subnet in module.ew1_hub.subnets : subnet.id if subnet.scope == "transitgateway"
  ]
  ue2_tgw_subnet_ids = [
    for subnet in module.ue2_hub.subnets : subnet.id if subnet.scope == "transitgateway"
  ]
}

module "ew1_tgw" {
  source = "./modules/transit_gateway"

  providers = {
    aws = aws.ew1
  }
  vpc_id     = module.ew1_hub.vpc_id
  base_cidr  = module.ew1_hub.vpc_cidr
  subnet_ids = local.ew1_tgw_subnet_ids
  aws_region = local.ipam_ew1_hub.region_name
  base_rt_id = module.ew1_hub.main_route_table_id
}

module "ue2_tgw" {
  source = "./modules/transit_gateway"

  providers = {
    aws = aws.ue2
  }
  vpc_id     = module.ue2_hub.vpc_id
  base_cidr  = module.ue2_hub.vpc_cidr
  subnet_ids = local.ue2_tgw_subnet_ids
  aws_region = local.ipam_ue2_hub.region_name
  base_rt_id = module.ue2_hub.main_route_table_id
}

#
# Create TGW peering attachment REQUESTS
#   Bear in mind these need to be manually approved in web console :/
resource "aws_ec2_transit_gateway_peering_attachment" "tpa_ue2_x_ew1" {
  # Peer region has to manually accept
  # Use naming convention to indicate initiator and requestor
  peer_region             = "eu-west-1"
  peer_transit_gateway_id = module.ew1_tgw.tgw_id
  transit_gateway_id      = module.ue2_tgw.tgw_id

  tags = {
    Name = "UE2 x EW1 peering attachment"
  }

  # Adding 'depends_on' statement to ensure TGW's are fully created
  depends_on = [module.ew1_tgw, module.ue2_tgw]
}

# #
# # Stage 2
# # - Transit Gateway backbone routing
# 
# #
# # Routing between TGW's depends on peering attachments being in place, but...
# # PEERING ATTACHMENTS MUST BE MANUALLY APPROVED IN WEB CONSOLE
# # So only add these TGW routes after having the peering approved.
# module "ew1_bb" {
#   source = "./modules/transit_gateway_backbone"
#   providers = {
#     aws = aws.ew1
#   }
# 
#   destinations = {
#     ue2 = {
#       dst_cidr_block = local.ipam_ue2_hub.region_cidr
#       attachment_id  = aws_ec2_transit_gateway_peering_attachment.tpa_ue2_x_ew1.id
#       route_table_id = module.ew1_tgw.tgw_association_default_route_table_id
#     }
#   }
# 
#   depends_on = [aws_ec2_transit_gateway_peering_attachment.tpa_ue2_x_ew1]
# }
# 
# module "ue2_bb" {
#   source = "./modules/transit_gateway_backbone"
#   providers = {
#     aws = aws.ue2
#   }
# 
#   destinations = {
#     ew1 = {
#       dst_cidr_block = local.ipam_ew1_hub.region_cidr
#       attachment_id  = aws_ec2_transit_gateway_peering_attachment.tpa_ue2_x_ew1.id
#       route_table_id = module.ue2_tgw.tgw_association_default_route_table_id
#     }
#   }
# 
#   depends_on = [aws_ec2_transit_gateway_peering_attachment.tpa_ue2_x_ew1]
# }
# 
# # #
# # # Stage 3
# # # - Adding spoke VPCs
# # 
# # locals {
# #   # Read ipam output file to create networks
# #   ipam_ew1_spoke_foov1 = jsondecode((file("${path.cwd}/ipam_spoke_eu-west-1-foo_v1.json")))
# # }
# # 
# # module "ew1_spoke_foov1" {
# #   source = "./modules/spoke"
# # 
# #   providers = {
# #     aws = aws.ew1
# #   }
# # 
# #   cidr_block = local.ipam_ew1_spoke_foov1.vpc_cidr
# #   vpc_name   = local.ipam_ew1_spoke_foov1.vpc_description
# #   subnets = {
# #     for idx, subnet in local.ipam_ew1_spoke_foov1.subnets :
# #     "subnet${idx + 1}" => {
# #       cidr              = subnet.cidr
# #       description       = subnet.description
# #       availability_zone = subnet.availability_zone
# #       ipam_id           = subnet.ipam_id
# #       scope             = subnet.scope
# #     }
# #   }
# #   tgw_id    = module.ew1_tgw.tgw_id
# #   tgw_rt_id = module.ew1_tgw.tgw_association_default_route_table_id
# #   app_name  = local.ipam_ew1_spoke_foov1.application_name
# # }
# # 