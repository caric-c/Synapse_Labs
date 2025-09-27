# main.tf

provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

# Call the VPC module
module "vpc" {
  source = "./terraform/modules/vpc"  # Path to your VPC module
}

# Call the RDS module
module "rds" {
  source = "./terraform/modules/rds-postgres"  # Path to your RDS module

  # Pass necessary variables to the RDS module
  allocated_storage    = 20  # Example value for allocated storage
  instance_class      = "db.t3.micro"  # Example instance class
  database_name       = "mydb"  # Database name
  master_username      = "admin"  # Master username
  master_password      = "password"  # Master password
  db_subnet_group_name = module.vpc.db_subnet_group_name  # Use subnet group from VPC module
  vpc_security_group_ids = [module.vpc.public_subnet_id]  # Security group, adjust as necessary
}

# Outputs for RDS
output "rds_instance_id" {
  value = module.rds.rds_instance_id  # Adjust based on your RDS module outputs
}



