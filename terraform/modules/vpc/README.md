<!--shoow path: show path : Synapse_Labs/terraform/modules/vpc/README.md -->

# Networking Guidelines

## Architecture Overview
- VPC CIDR: 10.0.0.0/16
- Public Subnets: 10.0.1.0/24 (for NAT, ALB, Bastion)
- Private Subnets: 10.0.2.0/24, 10.0.3.0/24 (for App, Database)

## Security Groups

### ALB Security Group
- Allows HTTP/HTTPS from internet (0.0.0.0/0)
- Sends traffic to Application SG only

### Application Security Group
- Allows HTTP/HTTPS only from ALB SG
- Can connect to Database SG
- Has outbound internet via NAT Gateway

### Database Security Group
- Allows database port only from Application SG
- No internet access

### Bastion Security Group (Optional)
- Allows SSH only from specified IP range
- Used for emergency access to private instances

## Network ACLs
Default NACLs are used with default allow rules. Custom NACLs can be implemented for additional layer of security.

## Access Patterns
- Internet → ALB → Application → Database
- Admin → Bastion → Application/Database (if needed)
