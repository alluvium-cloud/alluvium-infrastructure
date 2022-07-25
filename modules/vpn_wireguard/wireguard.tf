# resource "aws_eip" "wireguard" {
#   vpc = true
# }

# module "wireguard" {
#   source                 = "vainkop/wireguard/aws"
#   version                = "1.3.0"
#   region                 = var.data
#   ssh_key_id             = var.ssh_key_pair_id
#   subnets_ids            = var.public_subnets_id
#   vpc_id                 = var.vpc_id
#   wg_server_private_key  = var.wg_server_private_key
#   wg_client_ip           = var.wg_client_ip
#   wg_client_public_key   = var.wg_client_public_key
#   env                    = var.environment
#   instance_type          = var.instance_type
#   use_eip                = true
#   eip_id                 = aws_eip.wireguard.id
#   use_route53            = true
#   route53_hosted_zone_id = var.route53_hosted_zone_id
#   wg_server_net          = var.wg_server_net
#   wg_clients = [
#     {
#       "friendly_name" = "${var.environment}-home"
#       "public_key"    = var.wg_client_public_key
#       "client_ip"     = var.wg_client_ip
#     }
#   ]
# }


# region: us-east-1
# ssh_key_id: YOUR_SSH_KEY_HERE
# instance_type: t2.medium
# vpc_id: YOUR_VPC_ID_HERE
# subnet_ids:
#   - YOUR_SUBNET_ID_HERE
# use_eip: true
# use_ssm: true
# use_route53: true
# route53_hosted_zone_id: Z06401293ABC321ODE001
# route53_record_name: vpn.example.com
# route53_geo:
#   policy:
#   - continent: NA
# prometheus_server_ip: 0.0.0.0/0
# wg_server_net: 10.8.0.1/24
# wg_server_private_key: YOUR_SERVER_PRIVATE_KEY_HERE
# wg_clients:
#   - friendly_name: machine-1
#     public_key: MACHINE_1_PUBLIC_KEY_HERE
#     client_ip: 10.8.0.2/32
#   - friendly_name: machine-1
#     public_key: MACHINE_1_PUBLIC_KEY_HERE
#     client_ip: 10.8.0.3/32
