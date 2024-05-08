# Outputs

# spoke VPC outputs
output "vpc_arn" {
  value = aws_vpc.spoke.arn
}

output "vpc_id" {
  value = aws_vpc.spoke.id
}

output "vpc_cidr" {
  value = aws_vpc.spoke.cidr_block
}

output "main_route_table_id" {
  value = aws_vpc.spoke.main_route_table_id
}

output "default_route_table_id" {
  value = aws_vpc.spoke.default_route_table_id
}

output "default_network_acl_id" {
  value = aws_vpc.spoke.default_network_acl_id
}

output "default_security_group_id" {
  value = aws_vpc.spoke.default_security_group_id
}

# Subnets outputs
output "subnets" {
  value = {
    for idx, subnet in aws_subnet.subnets : idx => {
      id                = subnet.id
      arn               = subnet.arn
      cidr_block        = subnet.cidr_block
      vpc_id            = subnet.vpc_id
      availability_zone = subnet.availability_zone
      description       = subnet.tags.Name
      ipam_id           = subnet.tags.ipam_id
      scope             = subnet.tags.scope
    }
  }
}

output "tga_id" {
  description = "Transit Gateway Attachment ID"
  value = aws_ec2_transit_gateway_vpc_attachment.tga_spoke.id
}

output "r_id" {
  description = "Spoke route ID"
  value = aws_ec2_transit_gateway_route.r_spoke.id
}

