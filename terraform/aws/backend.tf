terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11.0"
    }
  }

  backend "s3" {
    bucket       = "infra-terraform-state2"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}