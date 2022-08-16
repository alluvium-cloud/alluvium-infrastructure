resource "aws_route53_record" "bastion" {
  count           = var.use_route53 ? 1 : 0
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "bastion.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = [aws_eip.bastion.public_ip]
}

resource "aws_route53_record" "bastion-internal" {
  count           = var.use_route53 ? 1 : 0
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "bastion-internal.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = [aws_instance.bastion.private_ip]
}

variable "instance_name" {
  default = "bastion"
}

data "hcp_packer_iteration" "alluvium-base" {
  bucket_name = "alluvium-base"
  channel     = "production"
}

data "hcp_packer_image" "alluvium-base" {
  bucket_name    = "alluvium-base"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.alluvium-base.ulid
  region         = var.region
}

resource "aws_instance" "bastion" {
  # checkov:skip=CKV_AWS_79: Not enabling instance metadata v2
  # checkov:skip=CKV_AWS_126: Not paying for additional monitoring
  # checkov:skip=CKV_AWS_8: No encryption needed
  # checkov:skip=CKV_AWS_88: Public IP is intentional
  ami                         = data.hcp_packer_image.alluvium-base.cloud_image_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bastion.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]

  tags = {
    Name        = "${var.environment}-bastion"
    Environment = var.environment
  }
  ebs_optimized = true
}


resource "aws_security_group" "bastion" {
  # checkov:skip=CKV_AWS_24: SSH open by intent
  name        = "${var.environment}-bastion-security-group"
  description = "Bastion Host Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH Inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port 80 inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port 443 inbound"
    from_port   = 443
    to_port     = 443
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

  egress {
    description = "Wide open egress"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-bastion-security-group"
    Environment = "${var.environment}"
  }
}


resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

resource "aws_key_pair" "bastion" {
  key_name_prefix = "${var.environment}-key"
  public_key      = var.ssh_public_key
}
