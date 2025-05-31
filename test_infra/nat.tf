module "nat" {
  source          = "../nat_instance"
  vpc_id          = aws_vpc.vpc.id
  private_subnets = aws_subnet.private_subnet[*].id
  public_subnet   = aws_subnet.public_subnet[*].id
  create_ssm_role = true
}