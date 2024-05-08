resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "rt_local_internet" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Local Internet Route Table"
  }
}

resource "aws_route" "r-ipv4-internet" {
  route_table_id         = aws_route_table.rt_local_internet.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "rt_assoc_ipv4-internet" {
  route_table_id = aws_route_table.rt_local_internet.id
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
}
