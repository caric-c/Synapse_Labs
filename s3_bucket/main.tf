# main.tf , ticket 01
# This file creates an S3 bucket with versioning and server-side encryption enabled
# Make sure to run `terraform apply` in this directory before using the backend

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Pinning to a major version
    }
  }
}

provider "aws" {
  region = "us-east-1" # Or your preferred region
}


resource "aws_s3_bucket" "s3_bucket" {
    bucket = "${var.project_name}-${var.environment}-${var.bucket_name}" # Unique bucket name


    tags = {
        Name        = var.bucket_name
        Environment = var.environment
    }
}
    
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
    bucket = aws_s3_bucket.s3_bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
    bucket = aws_s3_bucket.s3_bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}



resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket = "synapse-labs-terraform-state-dev" # Unique bucket name
    # acl    = "private"  # Set bucket access control (you can choose other options)


    tags = {
        Name        = "Terraform State Bucket"
        Environment = "Dev"
    }
}
