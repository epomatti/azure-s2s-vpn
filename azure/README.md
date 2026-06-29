# Azure

## Deployment

General configuration can be based off of [this article][azure-s2s-vpn-tutorial].

Start by creating the temporary keys for SSH authentication:

```sh
mkdir .keys && ssh-keygen -f .keys/azure
```

Copy the variables file:

```sh
cp config/local.auto.tfvars .auto.tfvars
```

Set the required values:

> [!TIP]
> You can get your current IP with `curl ifconfig.me`

Get the `pfSense` public IP from the `pfsense_firewall_host_elastic_public_ip` output.

```terraform
subscription_id            = "<SUBSCRIPTION_ID>"
public_ip_address_to_allow = ["<YOUR_IP>"]
vcn_shared_key             = "<SHARED KEY>"
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

https://youtu.be/K3-isCrb17o
https://youtu.be/Pg7dGDwNNPU
https://learn.microsoft.com/en-us/azure/vpn-gateway/nat-overview#mode
https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-compliance-crypto#what-algorithms-and-key-strengths-does-the-custom-policy-support

https://docs.fortinet.com/document/fortigate/8.0.0/administration-guide/255100/ipsec-vpn-to-azure-with-virtual-network-gateway
