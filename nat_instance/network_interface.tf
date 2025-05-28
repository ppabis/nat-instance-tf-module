resource "aws_network_interface" "private_eni" {
  subnet_id         = var.private_subnets[0]
  security_groups   = [aws_security_group.security_group.id]
  source_dest_check = false
}