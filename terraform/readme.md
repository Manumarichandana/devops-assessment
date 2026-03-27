---
## Table of Contents
 
---
 
- [Overview](#overview)
- [Repository Structure](#repository-structure)
  - [Architecture](#architecture)
  - [Prerequisites](#prerequisites)
  - [Quick Start](#quick-start)
  - [Configuration Reference](#configuration-reference)
  - [Endpoints](#endpoints)
  - [How to destroy](#how-to-destroy)
- [Keypoints](#keypoints)
 
---
 
  ## Overview
 
This repository contains the completed DevOps technical assessment consisting of two objectives:
 
| Objective | Description | Stack |
|-----------|-------------|-------|
| **1** | Provision and expose an EC2 instance via a public HTTP endpoint | Terraform, AWS EC2, Nginx |
 
## Repository Structure
```
devops-assessment/
│
├── terraform/                        # Objective 1 – Infrastructure as Code
│   ├── main.tf                       # Root module main.tf
│   ├── variables.tf                  # Input variables definitions
│   ├── outputs.tf                    # EC2 public IP output
│   ├── .gitignore                    # Excludes tfstate, credentials
│   └── modules/
│       └── ec2/                      # Reusable EC2 module
│           ├── main.tf               # AMI pulling, Security Group, EC2 instance
│           ├── variables.tf          # Module-level variable definitions
│           ├── outputs.tf            # Exposes public IP
│           └── userdata.sh           # Nginx install + endpoint configuration
 
```
 
### Architecture
 
```
Internet
    │
    ▼
┌─────────────────────────────────┐
│         AWS (eu-west-2)         │
│                                 │
│  ┌──────────────────────────┐   │
│  │      Security Group      │   │
│  │   Port 80  (HTTP)        │   │
│  │   Port 22  (SSH)         │   │
│  │   All outbound traffic   │   │
│  └──────────┬───────────────┘   │
│             │                   │
│  ┌──────────▼───────────────┐   │
│  │   EC2 – t3.micro         │   │
│  │   Amazon Linux 2         │   │
│  │   Nginx (via user-data)  │   │
│  │                          │   │
│  │  GET /         → 200     │   │
│  │  GET /health   → 200 OK  │   │
│  │  GET /version  → v1.0.0  │   │
│  └──────────────────────────┘   │
└─────────────────────────────────┘
```
 
### Prerequisites
 
| Requirement | Version |
|-------------|---------|
| Terraform   | ≥ 1.0   |
| AWS CLI | ≥ 2.0       |
| AWS Account | Free tier |
 
Configure AWS credentials:
```bash
aws configure
# Enter: Access Key ID, Secret Access Key, Region (eu-west-2), Output format (json)
```
 
### Quick Start
 
```bash
# 1. Clone the repository
git clone <your-repo-url>
cd devops-assessment/terraform
 
# 2. Initialise Terraform
terraform init
 
# 3. validate terraform's plan
terraform plan
 
# 4. Deploy infrastructure
terraform apply
# Type 'yes' when prompted
 
# 5. Note the output
# public_ip = "x.x.x.x"
```
 
> Please **Wait 1–2 minutes** once the terraform apply is finished to make room for the user-data script to finish installing and configuring Nginx.
 
### Configuration Reference
 
All variables include validation rules. Defaults are production-safe.
 
| Variable | Default | Allowed Values | Description |
|----------|---------|----------------|-------------|
| `region` | `eu-west-2` | `eu-west-2`, `us-east-1`, `us-west-2` | AWS deployment region |
| `instance_type` | `t3.micro` | `t2.micro`, `t3.micro` | EC2 instance size |
| `project_name` | `spectrum-life` | Any string | Tag applied to all resources |
| `allowed_http_cidr` | `0.0.0.0/0` | Any valid CIDR | IP range allowed on port 80 |
| `allowed_ssh_cidr` | `0.0.0.0/0` | Any valid CIDR | IP range allowed on port 22 |
| `key_name` | `null` | Any key pair name | SSH key access is optional|
 
To override defaults:
```bash
terraform apply \
  -var="region=us-east-1" \
  -var="instance_type=t2.micro" \
  -var="allowed_ssh_cidr=203.0.113.0/24"
```
 
### Endpoints
 
Replace `<public_ip>` with the IP from Terraform output.
 
| Endpoint | Method | Expected Response | Status |
|----------|--------|-------------------|--------|
| `http://<public_ip>/` | GET | `Chandana DevOps Assessment Running` | 200 |
| `http://<public_ip>/health` | GET | `OK` | 200 |
| `http://<public_ip>/version` | GET | `v1.0.0` | 200 |
 
### How to destroy
 
```bash
terraform destroy
# Type 'yes' when prompted
```
 
---
 
## Keypoints
 
### objective1 - keypoints
 
- The `ec2` module is fully reusable, any project can import it with different variable values. Root module handles project-specific configuration only.
- I have included validations in variable definitions to prevent accidental deployment to unsupported regions or instance types.
- Using `data "aws_ami"` block ensures the latest patched Amazon Linux 2 AMI is always used rather than a hardcoded, potentially outdated AMI.
- Fully automated provisioning, no manual SSH required after `terraform apply`.