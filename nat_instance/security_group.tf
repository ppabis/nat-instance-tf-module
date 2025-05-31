resource "aws_security_group" "security_group" {
  vpc_id      = var.vpc_id
  description = "Security group for NAT instance"
  name        = "NATInstanceSecurityGroup"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for subnet in data.aws_subnet.private_subnets : subnet.cidr_block]
  }
}