Document the module:
# RDS PostgreSQL Module

This module provisions a PostgreSQL RDS instance on AWS.

## Usage

```hcl
module "rds_postgres" {
  source = "path/to/your/module"
  
  database_name     = "your_db_name"
  master_username   = "your_username"
  master_password   = "your_password"
  security_group_id = "your_security_group_id"
}
