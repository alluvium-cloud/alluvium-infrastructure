resource "hcp_vault_cluster" "vault" {
  hvn_id          = var.hvn_id
  cluster_id      = "${var.environment}-vault"
  tier            = var.hcp_vault_tier
  public_endpoint = false
}
