# backend.tf
# this file configures the S3 backend for Terraform state storage
# Make sure to run `terraform apply` in the dynamodb directory before using this backend

terraform {
  backend "s3" {
    bucket         = "synapse-labs-terraform-state-dev" # You must create this unique bucket first
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locking" # You must create this DynamoDB table first
  }
}
