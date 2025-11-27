# Spoke Solution

This solution demonstrates a Spoke network deployment, typically used in a Hub-Spoke topology.

## Resources Deployed

- **Virtual Network**: The spoke VNet.
- **Route Table**: Custom routing for the spoke.
- **Network Security Groups**: Security rules for the spoke.

## Usage

1. Navigate to the directory:
   ```bash
   cd solutions/spoke-solution
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review `variables.tf` and provide necessary values.
4. Apply the configuration:
   ```bash
   terraform apply
   ```
