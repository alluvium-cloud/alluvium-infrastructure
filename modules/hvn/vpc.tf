# resource "aws_vpc_peering_connection_accepter" "peer" {
#   vpc_peering_connection_id = hcp_aws_network_peering.aws.provider_peering_id
#   auto_accept               = true
# }
#
# # Routes for HCP Subnets via HVN Peering Connection
# resource "aws_route" "public_hvn" {
#   route_table_id            = var.public_rtb_id
#   destination_cidr_block    = var.hvn_cidr
#   vpc_peering_connection_id = hcp_aws_network_peering.aws.provider_peering_id
# }
#
# resource "aws_route" "private_hvn" {
#   route_table_id            = var.private_rtb_id
#   destination_cidr_block    = var.hvn_cidr
#   vpc_peering_connection_id = hcp_aws_network_peering.aws.provider_peering_id
# }
#
# resource "aws_route" "default_hvn" {
#   route_table_id            = var.default_rtb_id
#   destination_cidr_block    = var.hvn_cidr
#   vpc_peering_connection_id = hcp_aws_network_peering.aws.provider_peering_id
# }

# resource "aws_security_group" "hcp_vault" {
#   name        = "${var.environment}-hcp-vault"
#   description = "SG for Vault Access"
#   vpc_id      = var.vpc_id

#   egress {
#     from_port   = "8200"
#     to_port     = "8200"
#     protocol    = "tcp"
#     cidr_blocks = [var.hvn_cidr]
#   }

#   tags = {
#     Name        = "${var.environment} <-> HVN (Vault)"
#     Environment = "${var.environment}"
#   }
# }

# aws ec2 --region us-west-2 authorize-security-group-ingress --group-id --ip-permissions IpProtocol=tcp,FromPort=8301,ToPort=8301,IpRanges='[{CidrIp=10.200.0.0/16}]' IpProtocol=udp,FromPort=8301,ToPort=8301,IpRanges='[{CidrIp=10.200.0.0/16}]' IpProtocol=tcp,FromPort=8301,ToPort=8301,UserIdGroupPairs='[{GroupId=}]' IpProtocol=udp,FromPort=8301,ToPort=8301,UserIdGroupPairs='[{GroupId=}]'
# aws ec2 --region us-west-2 authorize-security-group-egress --group-id --ip-permissions IpProtocol=tcp,FromPort=8300,ToPort=8300,IpRanges='[{CidrIp=10.200.0.0/16}]' IpProtocol=tcp,FromPort=8301,ToPort=8301,IpRanges='[{CidrIp=10.200.0.0/16}]' IpProtocol=udp,FromPort=8301,ToPort=8301,IpRanges='[{CidrIp=10.200.0.0/16}]' IpProtocol=tcp,FromPort=8301,ToPort=8301,UserIdGroupPairs='[{GroupId=}]' IpProtocol=udp,FromPort=8301,ToPort=8301,UserIdGroupPairs='[{GroupId=}]' IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=10.200.0.0/16}]' IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=10.200.0.0/16}]'

# resource "aws_security_group" "hcp_consul" {
#   name        = "${var.environment}-hcp-consul"
#   description = "SG for Consul Access"
#   vpc_id      = var.vpc_id

#   egress {
#     from_port   = "8300"
#     to_port     = "8300"
#     protocol    = "tcp"
#     cidr_blocks = [var.hvn_cidr]
#   }

#   tags = {
#     Name        = "${var.environment} <-> HVN (Vault)"
#     Environment = "${var.environment}"
#   }
# }
