# Azure Enterprise Landing Zone (Terraform)

![Terraform](https://img.shields.io/badge/Terraform-1.5+-5C4EE5)
![Azure](https://img.shields.io/badge/Azure-Cloud-blue)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-Terraform-green)

This repository contains the Terraform configuration for the **Azure Enterprise Landing Zone** — the secure hub networking foundation that all workloads in this platform depend on. It is the first infrastructure layer deployed after the Terraform state storage accounts.

---

## 🏗️ Platform Architecture

This landing zone is the hub in a **hub and spoke architecture**. All downstream workloads read from its Terraform remote state to consume networking outputs.

```
Terraform State (rg-tfstate-aks-enterprise)
        │
        ▼
Azure Enterprise Landing Zone  ◄── This repo
        │
        ├── AKS Test    (github.com/joshphillis/azure-enterprise-aks-test)
        ├── AKS Dev     (github.com/joshphillis/azure-enterprise-aks-dev)
        ├── AKS Prod    (github.com/joshphillis/azure-enterprise-aks-prod)
        └── VM Workload (github.com/joshphillis/azure-enterprise-workload-vm-stack)
```

> **Deployment order:**
> 1. **Terraform State** — storage accounts and containers must exist first
> 2. **This repo** — hub networking foundation
> 3. **Workloads** — AKS Dev/Test/Prod and VM Workload (read from this repo's remote state)

---

## 📦 Components

| Resource | Name | Purpose |
|---|---|---|
| Resource Group | `rg-enterprise` | Hub networking container |
| Virtual Network | `hub-vnet` | Hub VNet with all subnets |
| Azure Firewall | `hub-firewall` | Centralized egress control |
| Firewall Policy | `hub-firewall-policy` | AKS egress rules (aks-egress-rcg) |
| NAT Gateway | `enterprise-nat-gateway` | Outbound SNAT for AKS subnet |
| Bastion | `hub-bastion` | Secure VM access without public IPs |
| Route Table | `default-subnet-udr` | Forces egress through hub firewall |
| NSG | `default-subnet-nsg` | Network security for default subnet |
| Log Analytics | `hub-log` | Centralized logging and diagnostics |
| Public IPs | `hub-firewall-pip`, `hub-bastion-pip`, `nat-gateway-pip` | Outbound and management IPs |

---

## 🌐 Network Layout

| Subnet | CIDR | Purpose |
|---|---|---|
| `AzureFirewallSubnet` | `10.0.2.0/24` | Azure Firewall — required name |
| `AzureBastionSubnet` | `10.0.3.0/27` | Azure Bastion — required name |
| `aks-subnet` | `10.0.10.0/24` | AKS node pools (all environments) |
| `default` | `10.0.1.0/24` | VM workloads |

---

## 🔗 Remote State Outputs

Downstream workloads consume the following outputs from this landing zone's Terraform state:

| Output | Consumed By |
|---|---|
| `aks_subnet_id` | AKS Dev, AKS Test, AKS Prod |
| `firewall_private_ip` | AKS Dev, AKS Test, AKS Prod |
| `hub_default_subnet_id` | VM Workload |
| `nat_gateway_id` | AKS subnet association |
| `location` | All workloads |
| `resource_group_name` | VM Workload |

All workloads reference this state using:
```hcl
data "terraform_remote_state" "landing_zone" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate-aks-enterprise"
    storage_account_name = "sttfstateaksenterprise01"
    container_name       = "tfstate"
    key                  = "landing-zone.terraform.tfstate"
  }
}
```

---

## 🔥 Firewall Egress Rules

The firewall policy includes an `aks-egress-rcg` rule collection group required for AKS bootstrap and runtime egress:

| Rule | Destinations | Port |
|---|---|---|
| `aks-bootstrap` | `*.azmk8s.io`, `*.hcp.eastus.azmk8s.io`, `*.data.mcr.microsoft.com`, `acs-mirror.azureedge.net`, `data.policy.core.windows.net`, `store.policy.core.windows.net` | 443 |
| `container-registries` | `mcr.microsoft.com`, `*.azurecr.io` | 443 |
| `identity` | `login.microsoftonline.com`, `management.azure.com` | 443 |
| `linux-packages` | `packages.microsoft.com`, `*.ubuntu.com`, `archive.ubuntu.com` | 443 |

> All rules source from `10.0.10.0/24` (aks-subnet). Traffic is routed via `default-subnet-udr` with `outbound_type = "userDefinedRouting"` on all AKS clusters.

---

## 📁 File Structure

| File | Purpose |
|---|---|
| `main.tf` | Provider and core resource orchestration |
| `network.tf` | VNet, subnets, NAT gateway, route table, NSG |
| `firewall.tf` | Azure Firewall and firewall policy |
| `bastion.tf` | Azure Bastion for secure VM access |
| `log_analytics.tf` | Log Analytics workspace and diagnostics |
| `outputs.tf` | Remote state outputs consumed by workloads |
| `variables.tf` | Input variables |
| `backend.tf` | Remote state backend |
| `providers.tf` | Azure provider configuration |

---

## 🚫 Security Hygiene

This repo **does not contain**:
- `terraform.tfvars`
- `.terraform/` provider binaries
- `terraform.tfstate`
- Any secrets, credentials, or environment-specific values

All sensitive data is managed locally and excluded via `.gitignore`.

---

## 🚀 Deployment

### Prerequisites
- Terraform state storage accounts deployed first (`rg-tfstate-aks-enterprise`)
- Service principal with Contributor rights
- `terraform.tfvars` created locally (never commit this file)

### Deploy
```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### Validate firewall logs (KQL)
```kusto
AzureDiagnostics
| where ResourceType == "AZUREFIREWALLS"
| sort by TimeGenerated desc
```

---

## 📌 Notes

- All AKS clusters use `outbound_type = "userDefinedRouting"` — egress is firewall-controlled
- VMs in the `default` subnet are accessible via Bastion — no public IPs required
- The NAT gateway is associated with `aks-subnet` for SNAT
- The `default-subnet-udr` route table forces all traffic through `hub-firewall`

---

## 📈 Future Enhancements

- Add spoke VNet peering for additional workload isolation
- Expand firewall policy with DNAT rules for inbound traffic
- Add Azure DDoS Protection Plan
- Add GitHub Actions CI/CD pipeline for automated deployments
- Integrate Azure Policy for governance guardrails

---

## 🛡️ Author

**Joshua Phillis**
Retired Army Major | Cloud & Platform Engineer
GitHub: [@joshphillis](https://github.com/joshphillis)
