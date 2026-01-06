# Azure Landing Zone Demo
## Full Deployment Guide
➡️ [docs/deployment-guide.md](docs/deployment-guide.md)

![Terraform](https://img.shields.io/badge/Terraform-1.4+-5C4EE5)
![Azure](https://img.shields.io/badge/Azure-Cloud-blue)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-Terraform-green)

This repository documents my hands-on Azure landing zone build, including screenshots from the Azure portal and Terraform code.
# Enterprise Landing Zone – Azure Firewall Hub (Terraform)

## **Overview**

This repository documents and codifies a hands‑on deployment of an **Azure Enterprise Landing Zone (Hub)** using both the Azure Portal and Terraform.  
The environment includes:

- A dedicated **Resource Group**
- A **Hub Virtual Network** with multiple subnets
- An **Azure Firewall** with a Firewall Policy
- Public IPs for data plane and management plane
- A **Log Analytics Workspace**
- Diagnostic settings streaming firewall logs to Log Analytics
- A starter Terraform configuration that imports the existing firewall and codifies the rest of the environment

This repo demonstrates **real-world Azure engineering**, including manual deployment, validation, diagnostics, and reverse‑engineering into Infrastructure‑as‑Code.

EnterpriseLandingZone (Resource Group)
│
├── hub-vnet (Virtual Network)
│   ├── Default (10.0.0.0/24)                  → Baseline subnet
│   ├── hub-default (10.0.1.0/24)              → Hub workloads
│   ├── AzureFirewallSubnet (10.0.2.0/26)      → SNAT/DNAT traffic
│   └── AzureFirewallManagementSubnet (10.0.3.0/26) → Management NIC (forced tunneling)
│
├── az-fw-hub (Azure Firewall)
│   ├── Public IP: azfw-pip                    → Data plane
│   ├── Mgmt Public IP: azfw-mgmt-pip          → Management plane
│   └── Firewall Policy: az-fw-hub             → Attached during creation
│
└── law-hub (Log Analytics Workspace)
    └── Diagnostic Setting: fw-logs-to-law
        ├── ApplicationRule
        ├── NetworkRule
        ├── DNSProxy
        ├── NATRule
        ├── ThreatIntel
        └── All Metrics

---

## **Architecture Summary**

### **Resource Group**
```
EnterpriseLandingZone
```

### **Virtual Network: hub-vnet**
| Subnet Name | Address Range | Purpose |
|-------------|----------------|---------|
| Default | 10.0.0.0/24 | Baseline |
| hub-default | 10.0.1.0/24 | Hub workloads |
| AzureFirewallSubnet | 10.0.2.0/26 | Firewall data plane (SNAT/DNAT) |
| AzureFirewallManagementSubnet | 10.0.3.0/26 | Firewall management plane |

> **Note:** Azure requires the exact names `AzureFirewallSubnet` and `AzureFirewallManagementSubnet`.  
> Subnet purpose was set to **Azure Firewall** and **Firewall Management (forced tunneling)** during creation.

---

## **Azure Firewall Deployment**

### **Firewall**
- Name: `az-fw-hub`
- SKU: Standard
- Mode: VNet
- Management NIC enabled

### **Public IPs**
- `azfw-pip` (data plane)
- `azfw-mgmt-pip` (management plane)

### **Firewall Policy**
- Name: `az-fw-hub`
- Attached during firewall creation

### **Example Network Rule**
Rule Collection: `net-allow-dns`  
Priority: 100  
Action: Allow  
Rule:
- Source: `*`
- Protocol: UDP
- Destination: `8.8.8.8`
- Port: `53`

---

## **Log Analytics Workspace**
- Name: `law-hub`
- Region: East US
- Used for firewall diagnostics and Azure Monitor queries

---

## **Diagnostic Settings**
Diagnostic setting name: `fw-logs-to-law`

Logs sent to Log Analytics:
- AzureFirewallApplicationRule
- AzureFirewallNetworkRule
- AzureFirewallDnsProxy
- AzureFirewallNatRule
- AzureFirewallThreatIntel
- All Metrics

---

## **KQL Validation Query**

After deployment, firewall logs were validated using:

```kusto
AzureDiagnostics
| where ResourceType == "AZUREFIREWALLS"
| sort by TimeGenerated desc
```

This confirms that diagnostic settings and Log Analytics ingestion are functioning.

---

## **Terraform Integration**

This repo includes Terraform files that codify:

- Resource Group  
- Virtual Network  
- Subnets  
- Public IPs  
- Firewall Policy  
- Log Analytics Workspace  
- Azure Firewall (imported)

### **Important Note About Azure Firewall + Terraform**

The AzureRM provider **cannot fully model** all Azure Firewall properties, including:

- Management IP configuration  
- Some default Azure‑generated fields  
- Certain policy bindings  

As a result:

- `terraform plan` may show the firewall **“must be replaced”**  
- Running `terraform apply` on the firewall resource may attempt to **destroy and recreate** it  

### **Guidance**
- The firewall was imported for documentation and IaC demonstration  
- **Do NOT run `terraform apply` on the firewall resource in production**  
- This repo intentionally reflects real-world provider limitations

---

## **Terraform Files Included**

| File | Purpose |
|------|---------|
| `main.tf` | Provider + Terraform settings |
| `network.tf` | VNET + subnets |
| `public_ips.tf` | Firewall public IPs |
| `firewall.tf` | Imported Azure Firewall |
| `firewall_policy.tf` | Firewall Policy + example rule collection |
| `log_analytics.tf` | Log Analytics workspace |
| `variables.tf` | Address spaces, prefixes, region |
| `outputs.tf` | Key resource outputs |

---

## **How to Use This Repo**

### Initialize Terraform
```bash
terraform init
```

### View the plan
```bash
terraform plan
```

### Apply (safe resources only)
```bash
terraform apply
```

> **Do not apply changes to the firewall resource unless you intend to recreate it.**

---

## Screenshots

| Description | File |
|------------|------|
| Hub VNET and subnets | architecture/screenshots/vnet-subnets.png |
| Azure Firewall overview | architecture/screenshots/firewall-overview.png |
| Firewall Policy | architecture/screenshots/firewall-policy.png |
| Diagnostic Settings | architecture/screenshots/diagnostic-settings.png |
| Log Analytics KQL validation | architecture/screenshots/log-analytics-query.png |

## **Purpose of This Repository**

This repo demonstrates:

- Hands‑on Azure engineering  
- Correct creation of a hub network and firewall  
- Diagnostic configuration and KQL validation  
- Reverse‑engineering Azure resources into Terraform  
- Real-world IaC constraints and provider limitations  
- A clean, professional GitHub portfolio project for cloud engineering roles

## What I Learned

- Azure Firewall requires specific subnet names and address ranges.
- The Firewall Management NIC is only available when forced tunneling is enabled.
- Diagnostic settings must be explicitly configured to stream logs to Log Analytics.
- Terraform cannot fully model Azure Firewall resources due to provider limitations.
- Importing existing Azure resources into Terraform is a real-world workflow.

## Future Enhancements

- Add Terraform-managed diagnostic settings
- Add route tables and forced tunneling configuration
- Add spoke VNETs and peering to the hub
- Add Azure Bastion for secure management access
- Expand firewall policy with application and NAT rules

📘 Full Deployment Guide: [docs/deployment-guide.md](docs/deployment-guide.md)
