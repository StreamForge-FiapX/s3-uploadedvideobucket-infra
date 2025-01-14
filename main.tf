# Criar um bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = "uploaded-video-bucket"
  acl    = "private"

  tags = {
    Name        = "EKS Applications Bucket"
    Environment = "Production"
  }

  # Depende explicitamente da criação do EventBridge e do Event Bus
  depends_on = [aws_cloudwatch_event_bus.custom_event_bus]
}

# Criar uma política de bucket que permita acesso ao cluster EKS
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEKSApplicationsAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.eks_node_iam_role_arn # Substitua pelo ARN do papel IAM dos nós do EKS
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.my_bucket.arn}",
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })

  # Depende explicitamente da criação do EventBridge e do Event Bus
  depends_on = [aws_cloudwatch_event_bus.custom_event_bus]
}
