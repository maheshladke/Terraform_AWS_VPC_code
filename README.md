# AWS_VPC_CODE

Comprehensive Terraform code to create and manage an AWS Virtual Private Cloud (VPC) with public and private subnets, Internet Gateway, Route Tables, Network ACLs, and optional NAT Gateway.

## Features

- **VPC:** Configurable CIDR block with DNS support
- **Public Subnets:** Auto-assign public IP, associated with public route table
- **Private Subnets:** No public IP auto-assignment, optional NAT Gateway support
- **Internet Gateway:** For public subnet internet access
- **Route Tables:** Separate public and private route tables
- **Network ACLs:** Stateless firewall rules for public and private subnets
- **NAT Gateway:** Optional, for private subnet outbound internet access
- **Security Group:** Default VPC security group with inbound/outbound rules
- **Multi-AZ:** Subnets automatically distributed across available zones

## Prerequisites

- Terraform >= 1.5.0
- AWS credentials configured (environment variables, `~/.aws/credentials`, or IAM role)
- AWS account with appropriate permissions

## Quick Start

From the `AWS_VPC_CODE` directory:

```powershell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

## Variables

- `aws_region` — AWS region (default: `us-east-1`)
- `vpc_name` — VPC name tag (default: `main-vpc`)
- `vpc_cidr` — VPC CIDR block (default: `10.0.0.0/16`)
- `public_subnet_cidrs` — List of public subnet CIDRs (default: `["10.0.1.0/24", "10.0.2.0/24"]`)
- `private_subnet_cidrs` — List of private subnet CIDRs (default: `["10.0.10.0/24", "10.0.11.0/24"]`)
- `enable_nat_gateway` — Enable NAT Gateway (default: `false`)
- `enable_dns_hostnames` — Enable DNS hostnames (default: `true`)
- `enable_dns_support` — Enable DNS support (default: `true`)
- `tags` — Common tags for resources (default: Environment=development, ManagedBy=Terraform)

## Customize Variables

Create a `terraform.tfvars` file:

```hcl
aws_region = "us-west-2"
vpc_name   = "my-custom-vpc"
vpc_cidr   = "10.20.0.0/16"

public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
private_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]

enable_nat_gateway = true

tags = {
  Environment = "production"
  Team        = "platform"
  CostCenter  = "eng"
}
```

Then apply:

```powershell
terraform apply -var-file="terraform.tfvars" -auto-approve
```

Or override via command line:

```powershell
terraform apply -var="aws_region=eu-west-1" -var="enable_nat_gateway=true" -auto-approve
```

## Key Outputs

After `terraform apply`, retrieve output values:

```powershell
terraform output vpc_id
terraform output public_subnet_ids
terraform output private_subnet_ids
terraform output nat_gateway_eips
```

Or output all:

```powershell
terraform output
```

## Network Architecture

```
┌─────────────────────────── VPC (10.0.0.0/16) ──────────────────────────┐
│                                                                           │
│  ┌─────────────────────── Public Subnets ──────────────────────────┐    │
│  │  10.0.1.0/24 (AZ-a)  |  10.0.2.0/24 (AZ-b)                      │    │
│  │  ┌────────────────┐   ┌────────────────┐                        │    │
│  │  │  EC2 Instance  │   │  EC2 Instance  │                        │    │
│  │  └────────────────┘   └────────────────┘                        │    │
│  │  ↓                     ↓                                         │    │
│  │  └────────────────────────────────────────────────────────────┘    │    
│  │          ↓ (Route: 0.0.0.0/0 → IGW)                          │    │
│  │  [Internet Gateway]                                            │    │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                           │
│  ┌─────────────────────── Private Subnets ─────────────────────────┐    │
│  │  10.0.10.0/24 (AZ-a) | 10.0.11.0/24 (AZ-b)                      │    │
│  │  ┌────────────────┐   ┌────────────────┐                        │    │
│  │  │  EC2 Instance  │   │  EC2 Instance  │                        │    │
│  │  └────────────────┘   └────────────────┘                        │    │
│  │  ↓ (Optional NAT)     ↓ (Optional NAT)                          │    │
│  │  [NAT Gateway]        [NAT Gateway]   ← Requires EIPs           │    │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
```

## Destroy Resources

```powershell
terraform destroy -auto-approve
```

Or selectively destroy:

```powershell
terraform destroy -target=aws_nat_gateway.main -auto-approve
```

## Notes

- **No Sensitive Data:** This code contains no hardcoded secrets or IPs.
- **State Management:** Do not commit `terraform.tfstate` files; add to `.gitignore`.
- **Naming Convention:** All resources follow the pattern `{vpc_name}-{resource-type}`.
- **Multi-AZ:** Subnets are automatically distributed across available AZs for high availability.
- **NACL Rules:** Pre-configured for HTTP/HTTPS/SSH inbound; customize as needed.

## Advanced Customization

- Add more subnets by updating `public_subnet_cidrs` and `private_subnet_cidrs`
- Enable NAT Gateway with `enable_nat_gateway = true`
- Modify NACL rules in `main.tf`
- Add custom security groups and ingress/egress rules
- Integrate with other Terraform modules (e.g., for EC2, RDS)

## Troubleshooting

**State lock error:**
```powershell
terraform destroy -lock=false -auto-approve
```

**Verify VPC creation:**
```powershell
aws ec2 describe-vpcs --region us-east-1
```

**View subnets:**
```powershell
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxxxx" --region us-east-1
```
