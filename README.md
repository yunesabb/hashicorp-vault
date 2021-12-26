## Getting Started
Quick project to setup a GKE cluster and deploy Hashicorp's Vault as well as Traefik to expose it to the Internet.

### Deploy the GKE with terraform

```bash
cd terraform
terraform init
terraform apply
```

### Bootstrap the Vault and the Traefik
```bash
cd k8s
make deploy-vault
```

### Quick configuration  to initialize the Vault and configure the KV secret engine
```bash
cd k8s
make configure-vault
```