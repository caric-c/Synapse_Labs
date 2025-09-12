
# dynamodb.tf
# this file creates a DynamoDB table for Terraform state locking    
# Make sure to run `terraform apply` in this directory before using the backend


resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST" # You can also choose other billing modes
  
  attribute {
    name = "LockID"
    type = "S"
  }
  
  
  # set up TTL (Time to Live) for locks, this is optional
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }


  tags = {
    Name = "Terraform State Locking Table"
  }
}
