resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags = {
    Name = "${var.environment}-vault-kms-unseal-key"
  }
}

resource "aws_kms_alias" "vault" {
  name          = "alias/${var.environment}-vault-kms-unseal-key"
  target_key_id = aws_kms_key.vault.key_id
}

resource "aws_iam_user" "vault" {
  name = "vault-kms-unseal"
  tags = {
    Name = "vault-kms-unseal"
  }
}

resource "aws_iam_access_key" "vault" {
  user    = aws_iam_user.vault.name
  pgp_key = var.pgp_key
}

data "aws_iam_policy_document" "vault" {
  statement {
    sid       = "VaultKmsUnseal"
    effect    = "Allow"
    actions   = ["kms:DescribeKey", "kms:GenerateDataKey", "kms:Decrypt"]
    resources = [aws_kms_key.vault.arn]
  }
}

resource "aws_iam_policy" "vault" {
  name        = "vault-server-unseal"
  description = "Vault Server KMS Unseal"
  policy      = data.aws_iam_policy_document.vault.json
}

resource "aws_iam_user_policy_attachment" "vault" {
  user       = aws_iam_user.vault.name
  policy_arn = aws_iam_policy.vault.arn
}
