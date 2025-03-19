# Azure Site-to-Site VPN

Azure VPN-as-a-Service connection with pfSense.

<img src=".assets/azure-pfsense.png" />

## 1 - AWS Deployment

Commands are executed in the `azure` directory.

```sh
cd aws
```

Copy the configuration file:

```sh
cp config/local.auto.tfvars .auto.tfvars
```

```sh
terraform init
terraform apply -auto-approve
```

Connect to pfSense and setup the initial WAN configuration:

> [!NOTE]
> Get the password from the `pfsense-firewall` instance EC2 system log (can take a while to appear)

- Username: admin
- Password: <password>

Set up the VPN on the firewall server. Many options are available, of the most simple will be [IPSec Site-to-Site VPN with Pre-Shared Keys][ipsec-s2s-psk].

## 2 - Azure Deployment

Commands are executed in the `azure` directory. General configuration can be based off of [this article][azure-s2s-vpn-tutorial].

```sh
cd azure
```

Start by creating the temporary keys for SSH authentication:

```sh
mkdir .keys && ssh-keygen -f .keys/tmp_rsa
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
lgw_gateway_address        = "<PFSENSE_PUBLIC_IP>"
vcn_shared_key             = "00000000000000"
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

## 3 - Connection


[azure-s2s-vpn-tutorial]: https://learn.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal
[ipsec-s2s-psk]: https://docs.netgate.com/pfsense/en/latest/recipes/ipsec-s2s-psk.html
