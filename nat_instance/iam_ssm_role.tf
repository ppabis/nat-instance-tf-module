data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm_role" {
  name               = "NATInstanceSSMRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "NATInstanceSSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}