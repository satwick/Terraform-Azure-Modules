# Multi-Environment Workflow Setup Guide

## Overview
This guide explains how to configure environment-specific deployments using the `azure-deploy-multi-env.yml` workflow.

## How Environment Selection Works

### Branch-to-Environment Mapping
```
main branch    → production environment
staging branch → staging environment  
develop branch → dev environment
```

### Workflow Flow
```
Push to Branch
    ↓
Determine Environment Job
    ↓ (outputs: environment name)
    ↓
Plan Job (uses environment secrets)
    ↓
Apply Job (deploys to environment)
```

## Environment-Specific Configuration

### 1. GitHub Secrets Setup

For each environment, configure these secrets in GitHub:

#### Production Environment
**Path**: `Settings → Environments → production → Secrets`

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `AZURE_CLIENT_ID` | Production Service Principal ID | `12345678-1234-1234-1234-123456789abc` |
| `AZURE_SUBSCRIPTION_ID` | Production Azure Subscription | `abcdef12-3456-7890-abcd-ef1234567890` |
| `AZURE_TENANT_ID` | Azure AD Tenant ID | `98765432-9876-9876-9876-987654321098` |

> **Note on Authentication:** We use **OIDC (Federated Identity)**. You do NOT need to provide an `AZURE_CLIENT_SECRET`. Instead, configure federated identity credentials in your Azure App Registration for each GitHub Environment.

#### Staging Environment
**Path**: `Settings → Environments → staging → Secrets`

Same secrets as above, but pointing to **staging** Azure resources.

#### Dev Environment
**Path**: `Settings → Environments → dev → Secrets`

Same secrets as above, but pointing to **dev** Azure resources.

### 2. Environment Protection Rules

Configure approval requirements per environment:

#### Production
-  **Required reviewers**: 2 senior engineers
-  **Wait timer**: 5 minutes (optional)
-  **Deployment branches**: `main` only

#### Staging
-  **Required reviewers**: 1 engineer
-  **Wait timer**: None
-  **Deployment branches**: `staging` only

#### Dev
-  **Required reviewers**: None (auto-deploy)
-  **Wait timer**: None
-  **Deployment branches**: `develop` only

## Key Workflow Features Explained

### 1. Dynamic Environment Detection (Lines 24-44)
```yaml
determine-environment:
  steps:
    - name: Set Environment Based on Branch
      run: |
        if [[ "${{ github.ref }}" == "refs/heads/main" ]]; then
          echo "environment=production" >> $GITHUB_OUTPUT
```

**What it does**: Automatically determines which environment to deploy to based on the Git branch.

### 2. Environment-Specific Secrets (Lines 124-129)
```yaml
env:
  ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  ENVIRONMENT: ${{ needs.determine-environment.outputs.environment }}
```

**What it does**: 
- GitHub automatically pulls secrets from the **correct environment** (dev/staging/production)
- The `AZURE_SUBSCRIPTION_ID` from production environment points to production subscription
- The `AZURE_SUBSCRIPTION_ID` from dev environment points to dev subscription

### 3. Dynamic Environment Assignment (Lines 217-219)
```yaml
environment: 
  name: ${{ needs.determine-environment.outputs.environment }}
  url: https://portal.azure.com
```

**What it does**: 
- Sets the environment dynamically based on the branch
- Triggers the appropriate approval rules
- Uses the correct environment secrets

### 4. Terraform Workspaces (Lines 136-138)
```yaml
TF_WORKSPACE: ${{ needs.determine-environment.outputs.tf-workspace }}
```
```bash
terraform workspace select $TF_WORKSPACE || terraform workspace new $TF_WORKSPACE
```

**What it does**: Uses Terraform workspaces to isolate state between environments.

### 5. Environment-Specific tfvars (Lines 141-145)
```yaml
if [ -f "terraform.$ENVIRONMENT.tfvars" ]; then
  terraform plan -var-file="terraform.$ENVIRONMENT.tfvars" -out=tfplan
```

**What it does**: Allows you to have different variable files per environment:
- `terraform.production.tfvars`
- `terraform.staging.tfvars`
- `terraform.dev.tfvars`

## Directory Structure for Multi-Environment

```
deployment/
├── main.tf
├── variables.tf
├── terraform.dev.tfvars       # Dev-specific variables
├── terraform.staging.tfvars   # Staging-specific variables
└── terraform.production.tfvars # Production-specific variables
```

### Example: terraform.dev.tfvars
```hcl
resource_group_name = "rg-myapp-dev"
location           = "eastus"
vnet_name          = "vnet-myapp-dev"
vnet_address_space = ["10.0.0.0/16"]

tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  CostCenter  = "Development"
}
```

### Example: terraform.production.tfvars
```hcl
resource_group_name = "rg-myapp-prod"
location           = "eastus"
vnet_name          = "vnet-myapp-prod"
vnet_address_space = ["10.1.0.0/16"]

tags = {
  Environment = "production"
  ManagedBy   = "Terraform"
  CostCenter  = "Production"
}
```

## Deployment Workflow

### Deploy to Dev
```bash
git checkout develop
git add .
git commit -m "Add new feature"
git push origin develop
```
→ Automatically deploys to **dev** environment (no approval needed)

### Deploy to Staging
```bash
git checkout staging
git merge develop
git push origin staging
```
→ Deploys to **staging** environment (requires 1 approval)

### Deploy to Production
```bash
git checkout main
git merge staging
git push origin main
```
→ Deploys to **production** environment (requires 2 approvals + 5 min wait)

## Visual Flow

```
┌─────────────────────────────────────────────────────────┐
│  Developer pushes to branch                             │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  Workflow determines environment from branch            │
│  main → production                                      │
│  staging → staging                                      │
│  develop → dev                                          │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  GitHub loads secrets from that environment             │
│  production env → AZURE_SUBSCRIPTION_ID = <prod-sub>    │
│  dev env → AZURE_SUBSCRIPTION_ID = <dev-sub>            │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  Terraform authenticates to Azure                       │
│  Uses the subscription ID from environment secrets      │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  Apply jobs check environment protection rules          │
│  (Independent for hub, spoke, iot, deployment)          │
│  production → requires 2 approvals                      │
│  staging → requires 1 approval                          │
│  dev → no approval needed                               │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  Terraform applies to Azure in parallel                 │
│  (Each solution applies as soon as its plan finishes)   │
└─────────────────────────────────────────────────────────┘
```

## Comparison: Single vs Multi-Environment

### Your Current Workflow (Single Environment)
```yaml
environment: production  # Always production

env:
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  # Always uses the same subscription
```

### New Multi-Environment Workflow
```yaml
environment: 
  name: ${{ needs.determine-environment.outputs.environment }}
  # Dynamically set based on branch

env:
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  # GitHub automatically pulls from the correct environment
  # production environment → production subscription
  # dev environment → dev subscription
```

## Migration Steps

### 1. Create Environment-Specific Secrets
Set up dev, staging, and production environments in GitHub with their respective Azure credentials.

### 2. Create Environment-Specific tfvars
Create `terraform.dev.tfvars`, `terraform.staging.tfvars`, and `terraform.production.tfvars` files.

### 3. Set Up Branches
```bash
git checkout -b develop
git push origin develop

git checkout -b staging
git push origin staging
```

### 4. Configure Protection Rules
Set up approval requirements for each environment in GitHub Settings.

### 5. Test the Workflow
Push to `develop` branch first to test dev deployment.

## Troubleshooting

### Issue: "Secret not found"
**Cause**: Secret is not configured in the environment.
**Solution**: Go to `Settings → Environments → [env-name] → Secrets` and add the missing secret.

### Issue: "Workspace not found"
**Cause**: Terraform workspace doesn't exist yet.
**Solution**: The workflow automatically creates it with `terraform workspace new`.

### Issue: Deploying to wrong subscription
**Cause**: Environment secrets are pointing to wrong subscription.
**Solution**: Verify `AZURE_SUBSCRIPTION_ID` in each environment's secrets.

## Best Practices

- **Use separate Azure subscriptions** for dev/staging/production
- **Use separate service principals** per environment
- **Test in dev first**, then promote to staging, then production
- **Use environment-specific tfvars** for different configurations
- **Enable branch protection** on main and staging branches
- **Require approvals** for staging and production
- **Monitor costs** per environment using Azure Cost Management

## Questions?
Refer to the [GitHub Environments documentation](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment).
