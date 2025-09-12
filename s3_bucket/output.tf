# outputs.tf
# Outputs for the S3 bucket module
# This file defines the outputs that will be available after the S3 bucket is created.

output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket."
  value       = aws_s3_bucket.s3_bucket.arn
}

output "s3_bucket_id" {
  description = "The name (id) of the created S3 bucket."
  value       = aws_s3_bucket.s3_bucket.id
}
