# Terraform Approval Workflow

## Overview
This repository uses a **plan-review-approve-apply** workflow to ensure all Terraform changes are reviewed before being applied to Azure infrastructure.

## Workflow Steps

### 1. Create Feature Branch & Make Changes
```bash
# Create feature branch
git checkout -b feature/your-change-name

# Make your Terraform changes
# ...

# Format code
terraform fmt -recursive

# Commit and push
git add .
git commit -m "Description of changes"
git push origin feature/your-change-name
```

### 2. Open Pull Request
- Create a PR from your feature branch to `develop`
- The `azure-deploy.yml` workflow will automatically:
  - ✅ Run `terraform validate`
  - ✅ Run security scans (tfsec, Checkov)
  - ✅ Generate `terraform plan`
  - ✅ Post plan output as PR comment
  - ✅ Upload plan artifact

### 3. Review Terraform Plan
- Review the plan output posted in the PR comments
- Each solution/deployment will have its own plan comment
- Verify:
  - Resources to be created/modified/destroyed
  - No unexpected changes
  - Security scan results

### 4. Get PR Approval & Merge
- Request code review from team members
- Address any feedback
- Merge PR to `develop` once approved (This triggers auto-deployment to dev environment)

### 5. Manual Approval for Apply (Staging / Production)
- When promoting code to `staging` or `main`, the deployment `apply` jobs will start
- **The jobs will pause and wait for manual approval** (Dev deploys automatically)
- Approvers will be notified (configured in GitHub environment settings)
- Review the plan one final time
- Approve to proceed with `terraform apply`

### 6. Apply Executes
- Once approved, Terraform will apply the changes
- Monitor the workflow run for any errors
- Verify changes in Azure Portal

## Setting Up Manual Approval (One-Time Setup)

### Configure GitHub Environment Protection

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Environments**
3. Click on **production** (or create it if it doesn't exist)
4. Enable **Required reviewers**
5. Add team members who can approve deployments
6. (Optional) Set **Wait timer** to add a delay before deployment
7. (Optional) Set **Deployment branches** to restrict to `main` only

### Configuration Options

| Setting | Recommended Value | Purpose |
|---------|------------------|---------|
| Required reviewers | 1-2 senior engineers | Ensure human oversight before apply |
| Wait timer | 0 minutes | Optional delay (use if needed) |
| Deployment branches | `main` only | Prevent accidental deploys from feature branches |

## Approval Notification

When the apply job reaches the approval gate:
- Configured reviewers receive a notification
- The workflow run shows "Waiting for approval"
- Reviewers can:
  - ✅ **Approve** - Proceed with apply
  - ❌ **Reject** - Cancel the deployment

## Emergency Procedures

### Skip Approval (Not Recommended)
If you need to bypass approval in an emergency:
1. Temporarily remove required reviewers from environment
2. Re-run the workflow
3. **Remember to re-enable protection after**

### Rollback
If an apply causes issues:
1. Revert the merge commit on `main`
2. Push the revert
3. Approve the rollback apply

## Best Practices

- ✅ Always review plan output before merging PR
- ✅ Keep changes small and focused
- ✅ Test in a dev environment first if possible
- ✅ Document breaking changes in PR description
- ✅ Monitor Azure Portal during apply
- ❌ Don't approve your own deployments
- ❌ Don't rush approvals - take time to review

## Workflow Diagram

```
┌─────────────────┐
│ Feature Branch  │
│  (Make Changes) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Open PR to    │
│    develop      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Auto: Plan +   │
│  Security Scan  │
│  (Post Comment) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Human: Review  │
│  Plan in PR     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Human: Approve │
│   & Merge PR    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Auto: Start 4   │
│ Parallel applies│
┌─────────────────┐
│ ⏸️  PAUSE FOR   │
│ MANUAL APPROVAL │ ← YOU ARE HERE
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Human: Approve  │
│  in GitHub UI   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Auto: Parallel  │
│ Terraform Apply │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   ✅ Complete   │
└─────────────────┘
```

## Troubleshooting

### "No plan found" during apply
- This is normal if there were no changes detected
- The apply job will skip gracefully

### Plan shows unexpected changes
- Review what changed between plan and apply
- Check if someone else merged changes
- Consider re-running plan to get fresh output

### Approval not showing up
- Verify environment protection is configured
- Check that you're in the correct environment
- Ensure approvers are added to the environment

## Questions?
Contact the DevOps team or refer to the [GitHub Environments documentation](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment).
