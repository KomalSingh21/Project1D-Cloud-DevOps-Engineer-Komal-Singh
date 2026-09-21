# FinServ Digital — Payments Vault policy
# No real secrets are contained in this file.

path "secret/data/payments/*" {
  capabilities = ["read"]
}

path "secret/metadata/payments/*" {
  capabilities = ["list"]
}

path "transit/encrypt/payments-key" {
  capabilities = ["update"]
}

path "transit/decrypt/payments-key" {
  capabilities = ["update"]
}
