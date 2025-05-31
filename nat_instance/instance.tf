data "aws_ssm_parameter" "AL2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

locals {
  primary_subnet = var.private_subnets[0]
}

resource "aws_instance" "nat_instance" {
  ami                    = data.aws_ssm_parameter.AL2023.value
  instance_type          = "t4g.nano"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = var.public_subnet
  iam_instance_profile   = var.create_ssm_role ? aws_iam_instance_profile.ssm_instance_profile[0].name : null
  lifecycle { ignore_changes = [ami] }

  user_data = templatefile("${path.module}/user_data.yml", {
    private_subnets = values(data.aws_subnet.private_subnets)[*].cidr_block
    primary_subnet  = data.aws_subnet.private_subnets[local.primary_subnet].cidr_block
  })
}

resource "aws_eip_association" "nat_eip" {
  instance_id   = aws_instance.nat_instance.id
  allocation_id = aws_eip.elastic_ip.id
}

resource "aws_network_interface_attachment" "private_eni_attachment" {
  instance_id          = aws_instance.nat_instance.id
  network_interface_id = aws_network_interface.private_eni.id
  device_index         = 1
}