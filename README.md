# web-autoheal

This project sets up a small, highly available web tier in **Azure** using **Terraform**.   It runs NGINX on a **VM Scale Set** behind a **Load Balancer** so that if one VM goes down, another one takes over automatically.

## The goal is to demonstrate

- **Self-healing** (instances auto-replace on failure)  
- **N+1 availability** (at least 2 VMs running)  
- **IaC only** (Terraform manages everything)  

## What's Included

- Resource Group  
- Virtual Network & Subnet  
- Public Load Balancer (port 80 open)  
- VM Scale Set with NGINX installed  
- NSG to allow HTTP/SSH  

## How to Run

1. Make sure you have:
   - Terraform v1.13.3
   - Azure CLI installed and logged in (`az login`)

2. Run the below command to login with Service principal

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

We will get the below details as output::

  "appId": "XXXXXXXXXXX"  
  "displayName": "XXXXXXXXXXX"  
  "password": "XXXXXXXXXXX"  
  "tenant": "XXXXXXXXXXX”

```bash
az login --service-principal -u clientId -p password --tenant tenantId

export ARM_SUBSCRIPTION_ID="SUBSCRIPTION_ID"
```

3. Clone this repo:

   ```bash
   git clone https://github.com/tejalsingrol/web-autoheal
    ```

## Project Structure

```
web-autoheal/
│
├── providers.tf # Provider definition
├── variables.tf # Variable definition
├── secret.tf # Admin password
├── main.tf # Main Terraform config
├── output.tf # Output defination
│
└── README.md
```

## Deploy

- terraform init
- terraform plan
- terraform apply

## Test Self-Healing

1. Delete one VM from the scale set in the Azure portal.
2. The scale set will create a new one automatically.
3. The load balancer keeps serving traffic.

## Cost Estimate

Using B1s VMs and a basic load balancer, this should be under AUD $20/month if left running.

## Notes

Region used: australiaeast

## Author

TEJAL SHAH
