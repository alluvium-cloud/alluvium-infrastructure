resource "aws_route53_record" "wireguard" {
  count           = var.use_route53 ? 1 : 0
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "wireguard.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = [aws_eip.wireguard.public_ip]
}

resource "aws_route53_record" "wireguard-internal" {
  count           = var.use_route53 ? 1 : 0
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "wireguard-internal.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = [aws_instance.wireguard.private_ip]
}

data "template_file" "wg_client_data_json" {
  template = file("${path.module}/templates/client-data.tpl")
  count    = length(var.wg_clients)

  vars = {
    friendly_name        = var.wg_clients[count.index].friendly_name
    client_pub_key       = var.wg_clients[count.index].public_key
    client_ip            = var.wg_clients[count.index].client_ip
    persistent_keepalive = var.wg_persistent_keepalive
  }
}

data "hcp_packer_iteration" "alluvium-wireguard" {
  bucket_name = "alluvium-wireguard"
  channel     = "production"
}

data "hcp_packer_image" "alluvium-wireguard" {
  bucket_name    = "alluvium-wireguard"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.alluvium-wireguard.ulid
  region         = var.region
}

resource "aws_instance" "wireguard" {
  # checkov:skip=CKV_AWS_79: Not enabline metadata v2
  # checkov:skip=CKV_AWS_126: Not paying for additional monitoring
  # checkov:skip=CKV_AWS_8: No encryption needed
  # checkov:skip=CKV_AWS_88: Public IP is intentional
  ami                         = data.hcp_packer_image.alluvium-wireguard.cloud_image_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.wireguard.key_name
  associate_public_ip_address = true
  subnet_id                   = var.public_subnets_id[0]
  source_dest_check           = false

  vpc_security_group_ids = [aws_security_group.sg_wireguard.id]

  user_data = templatefile("${path.module}/templates/user-data.txt", {
    wg_server_private_key = var.wg_server_private_key,
    wg_server_net         = var.wg_server_net,
    wg_server_port        = var.wg_server_port,
    peers                 = join("\n", data.template_file.wg_client_data_json.*.rendered),
    wg_server_interface   = var.wg_server_interface
  })
  user_data_replace_on_change = true

  tags = {
    Name        = "${var.environment}-wireguard"
    Environment = var.environment
  }
  ebs_optimized = true
}


resource "aws_key_pair" "wireguard" {
  key_name_prefix = "${var.environment}-key"
  public_key      = var.ssh_public_key
}

resource "aws_eip" "wireguard" {
  vpc = true
  tags = {
    Name = "wireguard"
  }
}

resource "aws_eip_association" "wireguard" {
  instance_id   = aws_instance.wireguard.id
  allocation_id = aws_eip.wireguard.id
}

resource "aws_route" "public_home" {
  route_table_id         = var.public_rtb_id
  destination_cidr_block = var.home_cidr
  network_interface_id   = aws_eip_association.wireguard.network_interface_id
}

resource "aws_route" "private_home" {
  route_table_id         = var.private_rtb_id
  destination_cidr_block = var.home_cidr
  network_interface_id   = aws_eip_association.wireguard.network_interface_id
}

resource "aws_route" "default_home" {
  route_table_id         = var.default_rtb_id
  destination_cidr_block = var.home_cidr
  network_interface_id   = aws_eip_association.wireguard.network_interface_id
}

resource "aws_security_group" "sg_wireguard" {
  # checkov:skip=CKV_AWS_24: Wide open SSH for now
  name        = "${var.environment}-wireguard-${var.region}"
  description = "Terraform Managed. Allow Wireguard client traffic from internet."
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-wireguard-${var.region}"
    Project     = "wireguard"
    tf-managed  = "True"
    Environment = var.environment
  }

  ingress {
    description = "Allow connectivity to the Wireguard port"
    from_port   = var.wg_server_port
    to_port     = var.wg_server_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all known subnets to talk to others through this VPN host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.100.0.0/16", "10.200.0.0/16", "192.168.1.0/24"]
  }

  egress {
    description = "Wide open egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

