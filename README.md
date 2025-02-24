# AWS Infrastructure Automation with Terraform

![AWS Architecture](https://via.placeholder.com/800x400.png?text=Architecture+Diagram+-+Replace+With+Your+Own)

This README provides:

✅ Clear deployment instructions  
✅ Security documentation  
✅ Access methods  

Automatically provision a secure AWS environment with:
- 🛡️ Public Application Load Balancer (ALB)
- 🖥️ 3 ECS Fargate web servers ( Static Content)
- 🗄️ RDS PostgreSQL database (v17)
- 🌐 VPC with NAT/Internet Gateways
- 🔒 Security Groups with least-privilege access

## Prerequisites
- Terraform `>=1.0`
- AWS CLI configured with credentials
- AWS IAM user with permissions:
  - AmazonVPCFullAccess
  - AmazonECS_FullAccess
  - AmazonRDSFullAccess
  - SecretsManagerReadWrite

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/your-repo/aws-terraform-infra.git
cd aws-terraform-infra
```

### 2. Initialize Terraform
```bash
terraform init
```
### 3. Initialize Terraform
```bash
terraform plan
```

### 4. Deploy Infrastructure
```bash
terraform apply -auto-approve
```

## Configuration
Edit `variables.tf` to customize:

| Variable               | Default         | Description                  |
|------------------------|----------------|------------------------------|
| aws_region            | us-east-1      | AWS deployment region        |
| vpc_cidr              | 10.0.0.0/16    | VPC CIDR block               |
| db_instance_class     | db.t4g.micro   | RDS instance type            |
| backup_retention_period | 7              | Days to retain DB backups    |

## Outputs
```bash
# Get ALB endpoint
terraform output -raw alb_dns_name

# Get RDS endpoint (sensitive)
terraform output -raw db_endpoint
```

## Security Features
### 🔐 Secrets Management
- Database credentials stored in AWS Secrets Manager
- Automatic password generation/rotation

### 🛡️ Network Isolation
- Web servers in private subnets (no public IPs)
- RDS in dedicated isolated subnets
- Security group rules:

```
ALB → ECS: Port 80
ECS → RDS: Port 5432
```

### 🔒 Encryption
- RDS storage encryption enabled
- Secrets Manager encryption-at-rest

## Accessing Resources
### Web Application
```bash
# Test ALB endpoint
curl $(terraform output -raw alb_dns_name)
```
```bash
# Testing Round-Robin Load Balancing
To verify that requests are distributed across multiple ECS tasks, run:

bash
Copy
Edit
for i in {1..5}; do curl $(terraform output -raw alb_dns_name); echo ""; done
Each request should return a response from a different ECS task, demonstrating round-robin behavior.
```

## Cleanup
```bash
terraform destroy -auto-approve
```

## Note
```
I used my custom image, which takes container IPs from environment variables and displays them as a message. This helps test round-robin routing.
```







