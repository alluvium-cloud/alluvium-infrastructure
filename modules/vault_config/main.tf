provider "vault" {
  auth_login_userpass {
    username = var.TERRAFORM_USERNAME

  }
  alias     = "admin"
  namespace = "admin"
}

#--------------------------------------
# Create 'admin/alluvium' namespace
#--------------------------------------
# resource "vault_namespace" "alluvium" {
#   provider = vault.admin
#   path = "alluvium"
# }
