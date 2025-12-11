# Contributing to Terraform Azure Modules

Thank you for your interest in contributing! This document outlines the process for suggesting improvements and submitting pull requests.

## Development Process

1.  **Fork the repository** and create a feature branch (`feature/your-feature-name`).
2.  **Make your changes**. Ensure your code follows the existing style.
3.  **Run Tests**. Validate your changes locally:
    ```bash
    terraform fmt -recursive
    terraform validate
    ```
4.  **Commit changes**. Use descriptive commit messages.
5.  **Push and Open a PR**. Target the `main` branch.

## Code Standards

- **Terraform Version**: Use Terraform 1.5+ features where possible.
- **Formatting**: All files must be formatted with `terraform fmt`.
- **Documentation**: Update `README.md` files if you change variables or outputs.
- **Naming**: Follow [Azure Resource Naming Guidelines](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).

## CI/CD

Your PR will automatically trigger the following checks:
- Terraform Format Check
- Validation of Deployment and Solutions
- Security Scanning (tfsec, Checkov)

Please ensure all checks pass before requesting a review.
