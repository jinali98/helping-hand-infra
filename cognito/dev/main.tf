
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      Environment = var.prefix
      Service     = "AMC Cognito Authorizer"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "helping-hand-terraform-states-dev"
    key     = "cognito-authorizer/terraform.tfstate"
    region  = "ap-south-1"
    profile = "default"
  }
}


module "cognito_user_pool" {
  source                = "../auth"
  user_pool_name        = "helpingHand_auth_process_${var.prefix}"
  user_pool_client_name = "helpingHand_auth_process_client_${var.prefix}"
  env_prefix            = var.prefix
}