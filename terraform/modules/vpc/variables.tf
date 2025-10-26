# show path : Synapse_Labs/terraform/modules/vpc/variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to bastion"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key pair name for bastion host"
  type        = string
  default     = null
}


variable "bastion_instance_type" {
  description = "Instance type for the bastion"
  type        = string
  default     = "t3.micro"
}

variable "bastion_ami_ssm_parameter" {
  description = "SSM Parameter path to the AMI ID to use for bastion (defaults to Ubuntu 22.04 gp3)"
  type        = string
  default     = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

variable "db_port" {
  description = "Database port (3306=MySQL, 5432=Postgres)"
  type        = number
  default     = 3306
}

variable "enable_bastion" {
  description = "whether to create a bastion host"
  type        = bool
  default     = false
  
  # Validations
  validation {
    condition     = var.enable_bastion == false || (var.enable_bastion == true && var.allowed_ssh_cidr != null && var.key_name != null)
    error_message = "When enable_bastion is true, you must set allowed_ssh_cidr and key_name."
  }
}