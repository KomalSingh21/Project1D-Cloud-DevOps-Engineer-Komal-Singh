# FinServ Digital — Customer Vault policy
# No real secrets are contained in this file.

path "secret/data/customer/*" {
  capabilities = ["read"]
}

path "secret/metadata/customer/*" {
  capabilities = ["list"]
}

path "transit/encrypt/customer-key" {
  capabilities = ["update"]
}

path "transit/decrypt/customer-key" {
  capabilities = ["update"]
}
