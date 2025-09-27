# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Pinning to a major version
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "db_name_sg" {
  name        = "db-security-group"
  description = "Security group for database access"

  # No need to specify vpc_id to use the default VPC

  ingress {
    from_port   = 5432    # Port for PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Replace with your application server's CIDR block
  }

  tags = {
    Name = "DB Security Group"
  }
}


# DB Parameters:
# Engine: PostgreSQL-
# Engine Version: 15.x (latest stable)- 
# Instance Class: db.t3.micro (free tier eligible)
# Allocated Storage: 20 GB
# Storage Type: gp3 (modern, cost-effec  tive)
# Database Name: Configurable via variable
# Master Username & Password: Use variables (but we'll handle secrets properly)


resource "aws_db_instance" "postgres" {
  allocated_storage    = var.allocated_storage
  engine             = "postgres"
  engine_version     = "15.x"
  instance_class     = var.instance_class
  db_name            = var.database_name
  username           = var.master_username
  password           = var.master_password
  publicly_accessible = false
  storage_type       = "gp3"
  backup_retention_period = 7
  deletion_protection = var.deletion_protection

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "dev-postgres-instance"
  }
}

