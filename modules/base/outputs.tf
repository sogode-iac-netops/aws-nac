# Outputs

# Base VPC outputs
output "arn" {
    value = aws_vpc.base.arn
}

output "id" {
    value = aws_vpc.base.id
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

output "ipv6_association_id" {
    value = aws_vpc.base.ipv6_association_id
}

output "ipv6_cidr_block" {
    value = aws_vpc.base.ipv6_cidr_block
}

output "ipv6_cidr_block_network_border_group" {
    value = aws_vpc.base.ipv6_cidr_block_network_border_group
}

# Subnets outputs
output "subnets" {
    value = {
        for idx, subnet in aws_subnet.subnets : idx => {
            id = subnet.id
            arn = subnet.arn
            cidr_block = subnet.cidr_block
            vpc_id = subnet.vpc_id
            availability_zone  = subnet.availability_zone
            description        = subnet.tags.Name
            ipam_id            = subnet.tags.ipam_id
            scope              = subnet.tags.scope
        }
    }
}

# Internet Gateway output
output "internet_gateway_id" {
    value = aws_internet_gateway.internet_gateway.id
}

output "internet_gateway_arn" {
    value = aws_internet_gateway.internet_gateway.arn
}

output "rt_local_internet_id" {
    value = aws_route_table.rt_local_internet.id
}

output "rt_local_internet_arn" {
    value = aws_route_table.rt_local_internet.arn
}