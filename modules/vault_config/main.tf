provider "vault" {
  alias = "admin"
  namespace = "admin"
}

#--------------------------------------
# Create 'admin/alluvium' namespace
#--------------------------------------
resource "vault_namespace" "alluvium" {
  provider = vault.admin
  path = "alluvium"
}