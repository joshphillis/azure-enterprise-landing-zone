# Azure Enterprise Landing Zone

📸 Screenshots available in /architecture/screenshots

# ✅ **README.md — azure-enterprise-landing-zone**

```markdown
# Azure Enterprise Landing Zone

Fully automated, Terraform‑driven Azure foundation layer.

This repository deploys the shared enterprise landing zone that all downstream workloads depend on.  
It provides the core network, Bastion access, and remote state backend used by the VM workload stack.

---

## 📦 Components Deployed

- Resource Group (Landing Zone)
- Virtual Network (`hub-vnet`)
- Subnets:
  - `AzureBastionSubnet`
  - `default` (optional shared subnet)
- Azure Bastion Host
- Remote State Backend (Storage Account + Container)
- Tags and naming conventions

---

## 📁 Repository Structure

```
azure-enterprise-landing-zone/
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── terraform.tfvars   # created locally, not committed
```

---

## 🚀 Deployment (Local Machine or VS Code)

### 1. Authenticate to Azure
```
az login
```

### 2. Create the Terraform backend
```
az group create --name rg-tfstate-enterprise --location eastus

az storage account create \
  --name <your-storage-account> \
  --resource-group rg-tfstate-enterprise \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2

az storage container create \
  --name tfstate \
  --account-name <your-storage-account>
```

### 3. Create your `terraform.tfvars`
This file stays **local only** and includes:

- subscription_id  
- tenant_id  
- client_id  
- client_secret  
- state_rg  
- state_sa  
- state_container  
- state_key  
- location  
- tags  

### 4. Initialize and deploy
```
cd terraform
terraform init
terraform plan
terraform apply
```

---

## 🔗 Relationship to Other Repositories

This landing zone must be deployed **before** any workload repositories.  
Downstream stacks read remote state from this deployment.

---

## 🧹 Destroy

```
cd terraform
terraform destroy
```

If you want to remove the backend as well:
```
az group delete --name rg-tfstate-enterprise
```

---

## ✔️ Status

This repository has been validated end‑to‑end from a local machine using VS Code.
``
