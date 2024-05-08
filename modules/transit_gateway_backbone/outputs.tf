output "routes" {
  value = {
    for idx, route in aws_ec2_transit_gateway_route.routes : idx => {
      id                     = route.id
      destination_cidr_block = route.destination_cidr_block
    }
  }
}

