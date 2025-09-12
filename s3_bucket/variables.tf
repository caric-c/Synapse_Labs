# variables.tf
variable "bucket_name" {
  description = "the s3 bucket name, must be globally unique"
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3
    error_message = "The bucket name must be at least 3 characters long."
  }
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev" # Default value if not specified    
}

variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "MyApp" # Default value if not specified  
}



# variable "tags" {
#   description = "environment tag"
#   type        = map(string)
# }
