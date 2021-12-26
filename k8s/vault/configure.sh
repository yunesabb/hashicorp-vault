#!/bin/bash

echo -e "Printing Vault status"
kubectl -n vault exec vault-0 -- vault status

echo -e "Initializing Vault"
kubectl -n vault exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
sleep 2

echo -e "Unsealing Vault 0"
VAULT_UNSEAL_KEY=$(cat vault/cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl -n vault exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
sleep 10

echo -e "Joining and unsealing Vault 1 to cluster"
kubectl -n vault exec vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl -n vault exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
sleep 2

echo -e "Joining and unsealing Vault 2 to cluster"
kubectl -n vault exec vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl -n vault exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY
sleep2

echo -e "Enabling kv secret engine"
kubectl -n vault exec vault-0 -- vault secrets enable -path=production kv-v2
sleep 2

echo -e "Creating production kv secret engine and creating secret"
kubectl -n vault exec vault-0 -- vault kv put production/secret101 mysecret='hello world'
sleep 2

# User/Password auth metod creation

# User creation

# Policy creation for user to access production secret engine secrets