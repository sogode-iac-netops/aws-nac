# Outputs

# Base VPC outputs
output "vpc_arn" {
  value = aws_vpc.base.arn
}

output "vpc_id" {
  value = aws_vpc.base.id
}

output "vpc_cidr" {
  value = aws_vpc.base.cidr_block
}

output "main_route_table_id" {
  value = aws_vpc.base.main_route_table_id
}

output "default_route_table_id" {
  value = aws_vpc.base.default_route_table_id
}

output "default_network_acl_id" {
  value = aws_vpc.base.default_network_acl_id
}

output "default_security_group_id" {
  value = aws_vpc.base.default_security_group_id
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

