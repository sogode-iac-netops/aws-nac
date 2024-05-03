locals {
  # Read env.json as produced by prereqs
  env_data = jsondecode(file("${path.cwd}/env.json"))

  # get ipam info
  ipam_base = local.env_data.ipam_base
  ipam_token = local.env_data.ipam_token
  supernets = local.env_data.supernets
}

#resource "aws_vpc" "vpc_basis" {
#  cidr_block = "${terracurl_request.supernet.json.data}"
#  assign_generated_ipv6_cidr_block = true
#
#  tags = {
#    Name = "Basis VPC"
#    Owner = "NetOps"
#  }
#  lifecycle {
#    # Ignore any changes to the tags made outside of Terraform
#    ignore_changes = [ tags ]
#  }
#}
#