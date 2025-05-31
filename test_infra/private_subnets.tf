data "aws_availability_zones" "azs" {}

resource "aws_route_table" "private_route_table" {
  count  = var.test_count
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "test-private-route-table" }
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = module.nat.target_network_interface
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.test_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.${count.index + 2}.0/24"
  tags              = { Name = "test-private-subnet-${count.index}" }
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = var.test_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}