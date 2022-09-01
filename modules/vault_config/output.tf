output "vault_kms_key_id" {
  value = aws_kms_key.vault.id
}

output "vault_access_key" {
  value = aws_iam_access_key.vault.id
}
output "vault_secret_key" {
  value = aws_iam_access_key.vault.encrypted_secret
}
