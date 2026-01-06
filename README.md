# Azure Landing Zone Demo

This repository documents my hands-on Azure landing zone build, including screenshots from the Azure portal and Terraform code.
# Enterprise Landing Zone – Azure Firewall Hub (Terraform)

This repository codifies a subset of an Azure Enterprise Landing Zone using Terraform, focused on the **hub virtual network**, **Azure Firewall**, **firewall policy**, **public IPs**, and **Log Analytics**.

> Built from a real, hands-on Azure deployment and reverse-engineered into infrastructure as code.

## Architecture overview

- **Resource group:** `EnterpriseLandingZone`
- **Region:** `eastus`
- **Hub virtual network:** `hub-vnet`
  - `AzureFirewallSubnet`
  - `AzureFirewallManagementSubnet`
- **Azure Firewall:** `az-fw-hub`
  - Public IP: `azfw-pip`
  - Management Public IP: `azfw-mgmt-pip`
- **Firewall policy:** `az-fw-hub`
- **Log Analytics workspace:** `law-hub`

---

## Terraform layout

- `main.tf` – Provider and Terraform settings
- `network.tf` – Hub VNET and firewall subnets
- `public_ips.tf` – Firewall public IPs
- `firewall.tf` – Azure Firewall (imported from an existing deployment)
- `firewall_policy.tf` – Firewall policy and example rule collection group
- `log_analytics.tf` – Log Analytics workspace
- `variables.tf` – Tunable settings (location, address spaces)
- `outputs.tf` – Key IDs and names

---

## Import strategy and limitations

This repo is built from an existing Azure deployment. Key resources (like the firewall) were **imported** into Terraform state rather than created from scratch.

### Azure Firewall limitations

The current `azurerm` provider **cannot fully model** everything that exists on an Azure Firewall, including:

- Management IP configuration
- Some policy bindings
- Certain default or computed properties

As a result:

- `terraform plan` may show the firewall **"must be replaced"**.
- Running `terraform apply` on the firewall resource may attempt to **destroy and recreate** it.

### Important

- **Do NOT blindly run `terraform apply` on the firewall resource in production.**
- This repo is intended to:
  - Demonstrate hands-on Terraform usage
  - Show import workflows
  - Document real-world Azure architecture as code

For a production environment, you would typically:

- Start with non-destructive resources (VNETs, subnets, workspaces, diagnostic settings)
- Gradually migrate more firewall configuration into Terraform as provider support improves

---

## Usage

```bash
# Initialize providers
terraform init

# See what Terraform would do
terraform plan

# (Optional, and only in safe environments)
terraform apply
