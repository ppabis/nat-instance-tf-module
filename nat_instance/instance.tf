data "aws_ssm_parameter" "AL2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

resource "aws_instance" "nat_instance" {
  ami                         = data.aws_ssm_parameter.AL2023.value
  instance_type               = "t4g.nano"
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  subnet_id                   = var.public_subnet
  iam_instance_profile        = var.create_ssm_role ? aws_iam_instance_profile.ssm_instance_profile[0].name : null
  lifecycle { ignore_changes = [ami] }
}