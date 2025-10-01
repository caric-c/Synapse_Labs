# iam/main.tf
# This Terraform configuration creates an IAM policy with permissions for CloudWatch Alarms, S3,

resource "aws_iam_policy" "cloudwatch_permissions" {
  name        = "CloudWatchPermissions"
  description = "Permissions for CloudWatch Alarms, S3, RDS, and SNS"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      

      # CloudWatch permissions
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      },


        # S3 permissions
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::your-bucket-name"
      },

        # RDS permissions
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:ListTagsForResource"
        ]
        Resource = "*"
      },

      # SNS permissions
      {
        Effect = "Allow"
        Action = "sns:Publish"
        Resource = "arn:aws:sns:region:account-id:your-sns-topic-name"
      }
    ]
  })
}

# Attach the policy to an IAM role

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  policy_arn = aws_iam_policy.cloudwatch_permissions.arn
  role       = "your-iam-role-name"  # Replace with your IAM role name
}