# show path: Synapse_Labs/terraform/modules/security_hardening/cloudtrail.tf
# CloudTrail setup for logging and monitoring


# Create an S3 bucket for CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = var.cloudtrail_bucket_name
}


# remove the below block and use the aws_s3_bucket_versioning resource instead
#   versioning { 
#     enabled = true
#     }


# Use this resource to enable versioning on the bucket
resource "aws_s3_bucket_versioning" "cloudtrail_logs_versioning" {
    bucket = aws_s3_bucket.cloudtrail_logs.id
    versioning_configuration {
      status = "Enabled"
    }
  }


# remove the below block and use the aws_s3_bucket_server_side_encryption_configuration resource instead
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }


# Use this resource to enforce encryption on the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs_encryption" {
  bucket = aws_s3_bucket.cloudtrail_logs.id


  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Create a CloudWatch Log Group for CloudTrail logs
resource "aws_cloudwatch_log_group" "trail_logs" {
  name              = "/aws/cloudtrail/audit"
  retention_in_days = 90
}


# Create an IAM role for CloudTrail to assume
resource "aws_iam_role" "cloudtrail_role" {
  name = "CloudTrail_Logging_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = { Service = "cloudtrail.amazonaws.com" },
      Effect = "Allow",
      Sid = ""
    }]
  })
}


# Attach the necessary policies to the IAM role
resource "aws_cloudtrail" "main" {
  name                          = "org-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id # destination bucket for CloudTrail logs
  include_global_service_events = true # log global service events
  is_multi_region_trail         = true # log events from all regions
  enable_log_file_validation    = true # enable log file integrity validation
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.trail_logs.arn}:*" # CloudWatch Log Group ARN
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn # IAM Role ARN for CloudTrail to assume
}

