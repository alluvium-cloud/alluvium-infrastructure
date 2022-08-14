#---------------------------------------------------------------------------------------
# Packer Plugins
#---------------------------------------------------------------------------------------
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


#---------------------------------------------------------------------------------------
# Common Image Metadata
#---------------------------------------------------------------------------------------
variable "hcp_bucket_name" {
  default = "alluvium-wireguard"
}

variable "image_name" {
  default = "alluvium-wireguard"
}

variable "version" {
  default = "1.0.0"
}

variable "hcp_bucket_name_source" {
  default = "alluvium-base"
}

variable "hcp_channel_source" {
  default = "production"
}


#--------------------------------------------------
# HCP Packer Registry
# - Base Image Bucket and Channel
#--------------------------------------------------
# Returh the most recent Iteration (or build) of an image, given a Channel
data "hcp-packer-iteration" "alluvium-base" {
  bucket_name = var.hcp_bucket_name_source
  channel     = var.hcp_channel_source
}


#--------------------------------------------------
# AWS Image Config and Definition
#--------------------------------------------------
variable "aws_region" {
  default = "us-west-2"
}

data "hcp-packer-image" "aws" {
  cloud_provider = "aws"
  region         = var.aws_region
  bucket_name    = var.hcp_bucket_name_source
  iteration_id   = data.hcp-packer-iteration.alluvium-base.id
}

source "amazon-ebs" "alluvium-base" {
  region = var.aws_region
  source_ami = data.hcp-packer-image.aws.id
  instance_type  = "t3.micro"
  ssh_username = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_aws_{{timestamp}}_${var.image_name}_v${var.version}"
}


#---------------------------------------------------------------------------------------
# Common Build Definition
#---------------------------------------------------------------------------------------
build {

  hcp_packer_registry {
    bucket_name = "alluvium-wireguard"
    description = <<EOT
Alluvium Wireguard
    EOT
    bucket_labels = {
      "owner"          = "platform-team"
      "os"             = "Ubuntu"
      "ubuntu-version" = "Focal 20.04"
      "image-name"     = var.image_name
    }

    build_labels = {
      "build-time"        = timestamp()
      "build-source"      = basename(path.cwd)
      "alluvium-base-version" = var.version
    }
  }

  sources = [
    "sources.amazon-ebs.alluvium-wireguard"
  ]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::='--force-confnew'",
      "apt-get install -y apt-transport-https ca-certificates build-essential software-properties-common unzip curl wget gnupg net-tools jq wireguard-dkms wireguard-tools",
      "rm -rf /var/lib/apt/lists/*",
    ]

  }
}