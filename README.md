# Azure Enterprise Landing Zone

📸 Screenshots available in /architecture/screenshots

# ✅ **README.md — azure-enterprise-landing-zone**

Fully automated, Terraform‑driven Azure foundation layer.

This repository deploys the shared enterprise landing zone that all downstream workloads depend on.  
It provides the core network, Bastion access, and remote state backend used by the VM workload stack.

📸 Screenshots available in:  
`/architecture/screenshots`

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

---

## 🚀 Deployment (Local Machine or VS Code)

### 1. Authenticate to Azure

```bash
az login
```

---

### 2. Create the Terraform backend

```bash
az group create --name rg-tfstate-enterprise --location eastus
```

```bash
az storage account create \
  --name <your-storage-account> \
  --resource-group rg-tfstate-enterprise \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2
```

```bash
az storage container create \
  --name tfstate \
  --account-name <your-storage-account>
---

### 3. Create your terraform.tfvars

This file stays **local only** and includes:

```
subscription_id   = "<your-subscription-id>"
tenant_id         = "<your-tenant-id>"
client_id         = "<your-client-id>"
client_secret     = "<your-client-secret>"

state_rg          = "rg-tfstate-enterprise"
state_sa          = "<your-storage-account>"
state_container   = "tfstate"
state_key         = "enterprise.tfstate"

location          = "eastus"

tags = {
  environment = "dev"
  owner       = "<your-name>"
}
```

---

### 4. Initialize and deploy

```bash
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

```bash
cd terraform
terraform destroy
```

To remove the backend as well:

```bash
az group delete --name rg-tfstate-enterprise
```

---

## ✔️ Status

This repository has been validated end‑to‑end from a local machine using VS Code.
```
