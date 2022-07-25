resource "hcp_hvn" "main" {
  hvn_id         = "${var.environment}-${var.cloud_provider}-hvn"
  cloud_provider = var.cloud_provider
  region         = var.region
  cidr_block     = var.hvn_cidr
}

resource "hcp_aws_network_peering" "aws" {
  hvn_id          = hcp_hvn.main.hvn_id
  peering_id      = "${var.environment}-${var.cloud_provider}"
  peer_vpc_id     = var.vpc_id
  peer_account_id = var.owner_id
  peer_vpc_region = var.region
}

resource "hcp_hvn_route" "hvn-to-aws" {
  hvn_link         = hcp_hvn.main.self_link
  hvn_route_id     = "${var.environment}-hvn-to-aws"
  destination_cidr = var.vpc_cidr
  target_link      = hcp_aws_network_peering.aws.self_link
}

resource "hcp_hvn_route" "hvn-to-home" {
  hvn_link         = hcp_hvn.main.self_link
  hvn_route_id     = "${var.environment}-hvn-to-home"
  destination_cidr = var.home_cidr
  target_link      = hcp_aws_network_peering.aws.self_link
}


