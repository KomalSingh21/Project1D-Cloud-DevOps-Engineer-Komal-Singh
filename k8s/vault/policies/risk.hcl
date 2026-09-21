# FinServ Digital — Risk & Compliance Vault policy
# No real secrets are contained in this file.

path "secret/data/risk/*" {
  capabilities = ["read"]
}

path "secret/metadata/risk/*" {
  capabilities = ["list"]
}

path "transit/encrypt/risk-key" {
  capabilities = ["update"]
}

path "transit/decrypt/risk-key" {
  capabilities = ["update"]
}
