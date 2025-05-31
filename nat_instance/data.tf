data "aws_subnet" "private_subnets" {
  for_each = toset(var.private_subnets)
  id       = each.value
}