# CI/CD Pipeline Documentation

This repository uses GitHub Actions to ensure code quality and correctness.

## Workflows

**Terraform CI** (defined in `.github/workflows/terraform.yml`) triggers on:
- Push to `main` branch
- Pull requests to `main` branch

## Checks Performed

The pipeline runs the following checks:

1.  **Format Check**: 
    - Runs `terraform fmt -check -recursive`
    - Ensures all Terraform files follow standard formatting conventions.

2.  **Deployment Validation**:
    - Runs `terraform init` and `terraform validate` in the `deployment/` directory.
    - Verifies syntax and configuration validity for the main deployment example.

3.  **IoT Solution Validation**:
    - Runs `terraform init` and `terraform validate` in `solutions/iot/`.
    - validates the IoT reference architecture configuration.

4.  **Spoke Solution Validation**:
    - Runs `terraform init` and `terraform validate` in `solutions/spoke-solution/`.
    - Validates the Spoke Network reference architecture.

## How to Check Results

When you open a Pull Request:
1.  Navigate to the "Checks" tab or scroll to the bottom of the PR conversation.
2.  If a check fails, click "Details" to see the full log.
3.  Fix the issue locally (e.g., run `terraform fmt -recursive`) and push again.
