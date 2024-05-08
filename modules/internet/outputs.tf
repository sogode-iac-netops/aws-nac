#
# module internet output
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

