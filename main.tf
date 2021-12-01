terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws"{
    region = var.region
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}


