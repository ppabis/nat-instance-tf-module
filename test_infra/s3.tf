resource "aws_s3_bucket" "optional_test_bucket" {
  count         = var.test_bucket_name == "" ? 0 : 1
  bucket        = var.test_bucket_name
  tags          = { Name = "test-bucket-${var.test_bucket_name}" }
  force_destroy = true
}

resource "aws_s3_bucket_policy" "optional_test_bucket" {
  count  = var.test_bucket_name == "" ? 0 : 1
  bucket = aws_s3_bucket.optional_test_bucket[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.ec2.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.optional_test_bucket[0].arn,
          "${aws_s3_bucket.optional_test_bucket[0].arn}/*"
        ]
      }
    ]
  })
}