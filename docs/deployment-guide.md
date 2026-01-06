# **Azure Enterprise Landing Zone – Deployment Guide**

## **1. Create the Resource Group**

1. In the Azure Portal, select **Resource groups**  
2. Select **Create**  
3. Enter:
   - **Resource Group Name:** `EnterpriseLandingZone`
4. Select **Review + Create**
5. Select **Create**

---

## **2. Create the Hub Virtual Network**

1. Open the new resource group: **EnterpriseLandingZone**
2. Select **+ Create**
3. Search for **Virtual network**
4. Select **Create**
5. Configure:
   - **Resource group:** `EnterpriseLandingZone`
   - **Virtual network name:** `hub-vnet`
6. Select **Next** twice  
7. Keep the default subnet and address range  
8. Select **+ Add a subnet** twice to create:

### **Subnet Table**

| Name                          | Address Range | Purpose                               |
|-------------------------------|---------------|----------------------------------------|
| Default                       | 10.0.0.0/24   | Baseline                               |
| hub-default                   | 10.0.1.0/24   | Hub workloads                          |
| AzureFirewallSubnet           | 10.0.2.0/26   | Customer traffic (SNAT/DNAT)           |
| AzureFirewallManagementSubnet | 10.0.3.0/26   | Platform traffic (management NIC)      |

**Important:**  
When creating **AzureFirewallSubnet** and **AzureFirewallManagementSubnet**, set the **Subnet purpose** to:

- **Azure Firewall**
- **Firewall Management (forced tunneling)**

9. Select **Review + Create**
10. Select **Create**

---

## **3. Deploy Azure Firewall**

1. In the **EnterpriseLandingZone** resource group, select **+ Create**
2. Search for **Firewall**
3. Select **Create** under *Firewall (Microsoft)*

### **Firewall Settings**

- **Resource Group:** `EnterpriseLandingZone`
- **Name:** `az-fw-hub`
- **Firewall SKU:** Standard
- **Use a Firewall Policy:** Enabled

4. Select **Add new** for Firewall Policy  
   - Name: `az-fw-hub`

5. For **Virtual network**, select:
   - **Use Existing**
   - Choose `hub-vnet`

### **Public IP Addresses**

#### **Data Plane Public IP**
- Name: `azfw-pip`
- SKU: Standard
- Assignment: Static

#### **Management Public IP**
- Name: `azfw-mgmt-pip`
- SKU: Standard
- Assignment: Static

6. Ensure **Enable Firewall Management NIC** is selected  
7. Select **Next: Tags**  
8. Select **Next: Review + Create**  
9. Select **Create**

---

## **4. Add a Firewall Network Rule**

1. In the resource group, open **az-fw-hub Firewall Policy**
2. Under **Rules**, select **Rule collections**
3. Select **+ Add**
4. Choose **Rule collection**

### **Rule Collection Configuration**

- **Name:** `net-allow-dns`
- **Priority:** 100
- **Rule Type:** Network
- **Action:** Allow
- **Rule Collection Group:** `DefaultNetworkRuleCollectionGroup`

### **Rule Details**

- **Name:** `allow-dns`
- **Source Type:** IP Address  
- **Source:** `*`
- **Protocol:** UDP
- **Destination Type:** IP Address  
- **Destination:** `8.8.8.8`
- **Destination Ports:** `53`

---

## **5. Create Log Analytics Workspace**

1. In the resource group, select **+ Create**
2. Search for **Log Analytics**
3. Select **Create**
4. Configure:
   - **Resource Group:** `EnterpriseLandingZone`
   - **Name:** `law-hub`
5. Select **Review + Create**
6. Select **Create**

---

## **6. Configure Firewall Diagnostic Settings**

1. Open the **az-fw-hub** Firewall
2. Select **Monitoring**
3. Select **Diagnostic Settings**
4. Select **+ Add diagnostic setting**

### **Diagnostic Setting Configuration**

- **Name:** `fw-logs-to-law`

Enable the following logs:

- AzureFirewallApplicationRule  
- AzureFirewallNetworkRule  
- AzureFirewallDnsProxy  
- AzureFirewallNatRule  
- AzureFirewallThreatIntel  
- All Metrics  

Under **Destination**, select:

- **Send to Log Analytics Workspace**
- Accept defaults

Select **Save**

---

## **7. Validate Logs with KQL**

1. Open **law-hub** Log Analytics Workspace
2. Select **Logs**
3. Select **Tables**
4. Expand **LogManagement**
5. Select **AzureMetrics**
6. Select **+** to add a new query
7. Switch to **KQL mode**
8. Run:

```kusto
AzureDiagnostics
| where ResourceType == "AZUREFIREWALLS"
| sort by TimeGenerated desc
```

This confirms that firewall logs are flowing into Log Analytics.

