terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.102.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23.0"
    }
  }

  cloud {
    organization = "ericreeves-demo"
    hostname     = "app.terraform.io"

    workspaces {
      name = "alluvium-infrastructure"
    }
  }
}
