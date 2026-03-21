# CI/CD Pipeline Documentation

This repository uses GitHub Actions to automate Terraform validation and deployment with a multi-environment, OIDC-authenticated approach.

## 1. Reusable Workflow (`terraform-plan.yml`)
Contains the core foundational logic for Terraform. It is called by the other pipelines and handles:
- Code checking (`terraform fmt`)
- Initialization (`terraform init`)
- Security Scans (**tfsec**, **Checkov**)
- Validation and Planning (`terraform plan` with environment-specific `tfvars`)
- **Drift Detection** (Blocks pipeline if Azure resources changed outside of Terraform)
- **Infracost** Cost Estimation
- Publishing PR Comments with the plan and cost details.

## 2. PR Validation (`azure-deploy.yml`)
**Trigger:** Pull Requests targeting `develop` branch.
**Purpose:** Pre-merge validation. 
- Runs the reusable `terraform-plan.yml` in the `dev` environment context.
- Uses DEV credentials and the DEV state file.
- **Does NOT deploy anything.**
- Posts the Terraform Plan and Cost Estimate as comments on the PR so reviewers can evaluate the impact before merging.

## 3. Multi-Environment Deployment (`azure-deploy-multi-env.yml`)
**Trigger:** Push to `develop`, `staging`, or `main`.
**Purpose:** Actual deployment of infrastructure.

### The Flow:
1. **Determine Environment:** Detects branch (`develop` → `dev`, `staging` → `staging`, `main` → `production`).
2. **Plan (Parallel):** Uses the reusable workflow to securely plan changes for `hub-solution`, `spoke-solution`, `iot`, and `deployment` simultaneously.
3. **Apply (Parallel):** Once a specific solution's plan succeeds:
   - For `dev`: It deploys automatically.
   - For `staging`/`production`: It pauses and waits for **Manual Approval** in the GitHub UI (based on GitHub Environment Protection Rules).
   - Once approved, each solution applies independently.

## Authentication (OIDC)
This repository uses **OpenID Connect (OIDC)** for federated identity.
- We do **not** use `AZURE_CLIENT_SECRET`.
- You must configure a federated identity credential on your Azure AD App Registration for each environment, pointing to the GitHub repository environments.

## How to Check Results
When you open a Pull Request:
1. Navigate to the PR conversation.
2. The GitHub Actions bot will post the **Terraform Plan** and **Infracost Cost Estimate** directly in the comments.
3. If the plan fails, look for the `Checks` tab at the bottom to see logs and fix the issue.
