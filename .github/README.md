# CI/CD Pipeline

This repository uses GitHub Actions to ensure code quality and correctness.

## Workflows

### Terraform CI
Defined in `.github/workflows/terraform.yml`.

**Triggers:**
- Push to `main`
- Pull Request to `main`

**Checks:**
1.  **Format**: Checks if all Terraform files are formatted correctly (`terraform fmt`).
2.  **Validation**: Runs `terraform init` and `terraform validate` on:
    - `deployment/`
    - `solutions/iot/`

## How to Check Results
When you open a Pull Request, the checks will appear at the bottom. Click "Details" to see the logs if a check fails.
