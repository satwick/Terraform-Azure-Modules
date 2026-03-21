# Terraform Azure Modules

This repository contains reusable Terraform code for deploying resources on Microsoft Azure. Each folder under `modules/` represents a standalone module that can be integrated into your own Terraform configurations. The `deployment/` directory provides a simple example of how these modules can be consumed together.

[![Terraform CI](https://github.com/satwickcherukuri/Terraform-Azure-Modules/actions/workflows/terraform.yml/badge.svg)](https://github.com/satwickcherukuri/Terraform-Azure-Modules/actions/workflows/terraform.yml)

See [.github/README.md](.github/README.md) for details on the CI pipeline.

## Repository Structure

- **deployment/** – Sample root configuration demonstrating module usage.
- **modules/** – Collection of reusable Terraform modules:
  - **aks/** – Deploys an Azure Kubernetes Service cluster.
  - **application-gateway/** – Creates an Azure Application Gateway that can serve as an ingress controller.
  - **azure-sql-server/** – Provisions an Azure SQL Database server with a private endpoint.
  - **key-vault/** – Manages an Azure Key Vault instance.
  - **postgres-sql/** – Deploys a PostgreSQL Flexible Server.
  - **route-table/** – Defines custom route tables for virtual networks.
  - **storage-account/** – Creates a storage account with optional private endpoint and containers.
  - **v-net/** – Builds a virtual network and subnets for hub/spoke scenarios.
  - **vm-linux/** – Deploys a Linux virtual machine.
  - **vm-windows/** – Deploys a Windows virtual machine.
- **solutions/** – Reference architectures combining multiple modules:
  - **iot/** – Example IoT solution architecture.
  - **spoke-solution/** – Example spoke network deployment.

Each module contains its own `README.md` describing available variables, outputs and any specific considerations.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) 1.x installed
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed and authenticated
- Access to an Azure subscription with permission to create resources

## Getting Started

1. Change into the `deployment` directory:
   ```bash
   cd deployment
   terraform init
   ```
2. Review `variables.tf` and supply any required values, either by editing a `terraform.tfvars` file or via CLI variables.
3. Run Terraform to review and apply changes:
   ```bash
   terraform plan
   terraform apply
   ```

Refer to the module READMEs for detailed information on configuring each module.

## Future Roadmap

The following improvements are planned to elevate the repository to a production-grade standard:

- [ ] **Monorepo Strategy**: Switch `solutions/` to use relative paths for modules (`source = "../../modules/..."`) instead of remote git URLs to enable faster local development and testing.
- [x] **CI/CD Enhancements**:
    - [x] Add **Pull Request Plan Comments** to visualize infrastructure changes directly in PRs.
    - [x] Integrate **Infracost** for cost estimation in Pull Requests.
    - [ ] Implement **Renovate** or **Dependabot** for automated dependency updates.
- [ ] **Advanced Testing**: Introduce **Terratest** (Go) for integration testing to validate that creating infrastructure actually works as expected.
- [ ] **Security**:
    - [ ] Configure `hard_fail` for critical security rules in `tfsec`/`checkov`.
    - [ ] Implement deeper drift detection monitoring.
- [ ] **Documentation**: Generate automated architecture diagrams (e.g., using `pluralith` or `inframap`) in CI.
