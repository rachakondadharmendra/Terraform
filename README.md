# Terraform Infrastructure Repository For ECS.

This repository creates an AWS pipeline and an Amazon ECS cluster for deploying and running an application.

## Architecture Diagram Overview:
- The architecture illustrates a 3-tier application structure across 3 Availability Zones (AZs), ensuring robustness and scalability.
- Prior to implementing in the database tier, optimize performance by designating one database for read and write operations, while reserving others exclusively for read operations.
- Although initially utilizing 3 NAT Gateways, consider consolidating to 1 to enhance cost-effectiveness without compromising functionality.

## Architecture Diagram

![Architecture Diagram](https://github.com/rachakondadharmendra/Ops-Knowledge-Base/blob/main/Arch-Daigrams/ECS-3-Tier-Arch-Daigram.gif)


## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/rachakondadharmendra/Terraform.git
   cd Terraform
   ```

2. **Cluster Creation**:
   Navigate to the `environments/dev/ecommerce-demo/` directory and execute the following commands:
   ```bash
   cd environments/dev/ecommerce-demo/
   terraform init
   terraform plan -out=plan -var-file="../../../var/dev/ecommercedemo.tfvars"
   terraform apply "plan"
   ```

3. **Pipeline Creation**:
   Move to the `Terraform/pipeline` directory and run the following commands:
   ```bash
   cd Terraform/pipeline
   terraform init
   terraform plan -out=plan
   terraform apply "plan"
   ```

