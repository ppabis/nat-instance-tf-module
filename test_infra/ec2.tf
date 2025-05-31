data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

resource "aws_security_group" "test_instance" {
  name   = "test-instance-security-group"
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "test-instance-security-group" }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test_instance" {
  count                  = var.test_count
  ami                    = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = "t4g.nano"
  subnet_id              = aws_subnet.private_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.test_instance.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  tags                   = { Name = "test-instance-${count.index}" }
}

output "test_instance_ids" {
  value = aws_instance.test_instance[*].id
}