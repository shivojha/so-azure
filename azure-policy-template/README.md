# Azure Policy as Code – Terraform Implementation

This repo contains an example of implementing Azure governance using custom Azure Policies written in Terraform.

## 🔧 Use Cases

- Deny Public IPs on NICs
- Require 'Environment' tag on all resources

## 📦 Structure

- `main.tf` – Policy definitions and assignments
- `variables.tf` – Environment-specific input values

## 🚀 Usage

```bash
terraform init
terraform apply -var='tenant_id=xxxx' -var='target_scope=/subscriptions/xxxx'
```

## 📈 Outcome

Secure and compliant resource deployments at scale.

## 🧠 Author

**shivojha** – Principal Engineer | Azure Architect
