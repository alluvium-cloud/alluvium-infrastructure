resource "random_id" "random_id_prefix" {
  byte_length = 2
}

# Adding multiple AZ's to this array will work as long as you
# supply an array with an equivalent number of subnets for
# var.public_subnets_cidr and var.private_subnets_cidr
locals {
  availability_zones = ["${var.region}a"]
}

module "aws_network" {
  source                    = "./modules/aws_network"
  environment               = var.environment
  region                    = var.region
  vpc_cidr                  = var.vpc_cidr
  public_subnets_cidr       = var.public_subnets_cidr
  private_subnets_cidr      = var.private_subnets_cidr
  public_subnets_dhcp_cidr  = var.public_subnets_dhcp_cidr
  private_subnets_dhcp_cidr = var.private_subnets_dhcp_cidr
  availability_zones        = local.availability_zones
  instance_type             = var.instance_type
  ssh_public_key            = var.ssh_public_key
  use_route53               = true
  route53_domain_name       = var.route53_domain_name
  route53_hosted_zone_id    = var.route53_hosted_zone_id
}

module "hvn" {
  source         = "./modules/hvn"
  cloud_provider = var.cloud_provider
  environment    = var.environment
  region         = var.region
  vpc_cidr       = var.vpc_cidr
  hvn_cidr       = var.hvn_cidr
  home_cidr      = var.home_cidr
  vpc_id         = module.aws_network.vpc_id
  owner_id       = module.aws_network.owner_id
  public_rtb_id  = module.aws_network.public_rtb_id
  private_rtb_id = module.aws_network.private_rtb_id
  default_rtb_id = module.aws_network.default_rtb_id
}

module "hcp_vault" {
  source         = "./modules/hcp_vault"
  environment    = var.environment
  hvn_id         = module.hvn.hvn_id
  hcp_vault_tier = var.hcp_vault_tier
}

module "vault_config" {
  source         = "./modules/vault_config"
}

module "hcp_boundary" {
  source         = "./modules/hcp_boundary"
  environment    = var.environment
  hcp_boundary_admin_username = var.hcp_boundary_admin_username
  hcp_boundary_admin_password = var.hcp_boundary_admin_password
}

# module "vault_kms" {
#   source      = "./modules/vault_kms"
#   environment = var.environment
#   pgp_key     = var.pgp_key
# }

# module "vpn_wireguard" {
#   source                 = "./modules/vpn_wireguard"
#   environment            = var.environment
#   region                 = var.region
#   vpc_id                 = module.aws_network.vpc_id
#   public_subnets_id      = module.aws_network.public_subnets_id
#   instance_type          = var.instance_type
#   ssh_public_key         = var.ssh_public_key
#   wg_server_private_key  = var.wg_server_private_key
#   wg_server_net          = var.wg_server_net
#   use_route53            = true
#   route53_domain_name    = var.route53_domain_name
#   route53_hosted_zone_id = var.route53_hosted_zone_id
#   home_cidr              = var.home_cidr
#   public_rtb_id          = module.aws_network.public_rtb_id
#   private_rtb_id         = module.aws_network.private_rtb_id
#   default_rtb_id         = module.aws_network.default_rtb_id
#   wg_clients = [
#     {
#       "friendly_name" = "${var.environment}-home"
#       "public_key"    = var.wg_client_public_key
#       "client_ip"     = var.wg_client_ip
#     }
#   ]
# }

# module "static_website" {
#   source                 = "./modules/static_website"
#   static_website_name    = "devops.alluvium.cloud"
#   route53_hosted_zone_id = var.route53_hosted_zone_id
# }
