
variable "region" {
  description = "AWS region for the RDS instance"
  type        = string
  default     = "us-east-1" # Default value if not specified 
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 10 # Default value if not specified 
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t2.micro" # Default value if not specified 
}

variable "database_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb" # Default value if not specified
}

variable "master_username" {
  description = "The database admin username"
  type        = string
}

variable "master_password" {
  description = "The database admin password"
  type        = string
  sensitive   = true
}

variable "security_group_id" {
  description = "Security Group ID for the RDS instance"
  type        = string
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true # Default value if not specified
}
