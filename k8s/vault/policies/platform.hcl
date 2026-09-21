# FinServ Digital — Platform Vault policy
# No real secrets are contained in this file.

path "secret/data/platform/*" {
  capabilities = ["read"]
}

path "secret/metadata/platform/*" {
  capabilities = ["list"]
}

path "transit/encrypt/platform-key" {
  capabilities = ["update"]
}

path "transit/decrypt/platform-key" {
  capabilities = ["update"]
}
