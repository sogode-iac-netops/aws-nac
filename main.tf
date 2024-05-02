locals {
  # Read env.json as produced by prereqs
  env_data = jsondecode(file("${path.cwd}/env.json"))

  # get ipam info
  ipam_base = local.env_data.ipam_base
  ipam_token = local.env_data.ipam_token
  supernets = local.env_data.supernets
}

data "phpipam_first_free_subnet" "vpc_subnets" {
    for_each = {
      for index, supernet in local.supernets:
      index => supernet
    }
    subnet_id = each.value.id
    subnet_mask = 24
}

resource "phpipam_subnet" "vpc_cidrs" {
    for_each = {
      for index, supernet in local.supernets:
      #supernet.id => supernet
      index => supernet
    }
    section_id = local.env_data.section_id
    master_subnet_id = each.value.id
    subnet_address = split("/", data.phpipam_first_free_subnet.vpc_subnets[each.key].ip_address)[0]
    subnet_mask = split("/", data.phpipam_first_free_subnet.vpc_subnets[each.key].ip_address)[1]
    description = "VPC ${each.key} cidr"
}

output "vpc_cidrs" {
  value = [ for r in data.phpipam_first_free_subnet.vpc_subnets : r.ip_address]
}