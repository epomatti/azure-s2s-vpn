# azure-s2s-vpn

## Deployment

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

https://learn.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal
