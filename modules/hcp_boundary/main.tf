resource "hcp_boundary_cluster" "boundary" {
  cluster_id = "${var.environment}-boundary"
  username   = var.hcp_boundary_admin_username
  password   = var.hcp_boundary_admin_password
}