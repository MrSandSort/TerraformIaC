# Terraform-InfrastructureAsACode
 A Terraform project to automate the provisioning of cloud infrastructure. This repository includes code to set up VPCs, subnets, EC2 instances, security groups, and other essential components on AWS using infrastructure as code (IaC) practices. Ideal for DevOps automation, reproducibility, and version control of infrastructure deployments.
# Terraform Infrastructure Setup

This repository contains Terraform code to provision AWS cloud infrastructure automatically. The configuration follows infrastructure-as-code principles and is modular and reusable.

## 🚀 Features

- VPC creation
- Public and private subnets
- Internet Gateway and NAT Gateway
- Route tables and associations
- EC2 instance provisioning
- Security groups setup
- Scalable and configurable using variables

## 📦 Prerequisites

- [Terraform](https://www.terraform.io/downloads)
- AWS CLI configured with proper credentials
- Git

## 🛠 Usage

1. Clone the repo:

   ```bash
   git clone https://github.com/MrSandSort/TerraformIaC/

2. For ec2 instances

   ```bash
   cd instance

3. For Virtual Private Cloud(VPC):
   ```bash
   cd vpc
      
 4. Terraform commands:
    ```bash
    terraform init
    terraform plan
    terraform apply  
