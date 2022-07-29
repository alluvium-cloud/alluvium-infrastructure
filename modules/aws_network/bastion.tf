variable "instance_name" {
  default = "bastion"
}

data "hcp_packer_iteration" "ubuntu-web" {
  bucket_name = "ubuntu-web"
  channel     = "production"
}

data "hcp_packer_image" "ubuntu-web" {
  bucket_name    = "ubuntu-web"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.ubuntu-web.ulid
  region         = var.region
}

resource "aws_instance" "bastion" {
  ami                         = data.hcp_packer_image.ubuntu-web.cloud_image_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bastion.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet[0].id

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name        = "${var.environment}-bastion"
    Environment = var.environment
  }
}

resource "aws_security_group" "bastion" {
  name = "${var.environment}-bastion-security-group"

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
