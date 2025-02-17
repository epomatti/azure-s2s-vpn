# Azure Site-to-Site VPN



## 1 - Azure Deployment

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

```terraform
subscription_id            = ""
public_ip_address_to_allow = [""]
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

## 2 - AWS Deployment

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

## 3 - Connection


[azure-s2s-vpn-tutorial]: https://learn.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal
