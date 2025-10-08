# show path: Synapse_Labs/terraform/modules/security_hardening/variables.tf


# IAM Developer group Usernames
variable "developer_usernames" {
  type        = list(string)
  description = "List of IAM usernames to add into the developer group"
  default     = [] #safe default to empty list
}


variable "cloudtrail_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store CloudTrail logs"
  default = "my-cloudtrail-logs-bucket" #safe default
}


variable "mfa_user_arn" {
  type        = string
  description = "The ARN of the IAM user who can assume the break glass role"
  default = "values.user.arn" #safe default
}

variable "region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1" #safe default     
  
}
