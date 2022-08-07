
resource "aws_route53_record" "wireguard" {
  count           = var.use_route53 ? 1 : 0
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = var.route53_record_name
  type            = "A"
  ttl             = "60"
  records         = [aws_eip.wireguard.public_ip]
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

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "wireguard" {
  ami                         = data.aws_ami.ubuntu.id
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
    from_port   = var.wg_server_port
    to_port     = var.wg_server_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.100.0.0/16", "10.200.0.0/16", "192.168.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

