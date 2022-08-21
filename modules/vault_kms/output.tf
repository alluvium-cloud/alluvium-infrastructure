output "vault_kms_key_id" {
  value = aws_kms_key.vault.key_id
}

output "vault_kms_key_alias" {
  value = aws_kms_alias.vault.name
}
