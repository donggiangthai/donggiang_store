provider "aws" {
  # shared_config_files      = ["%USERPROFILE%\\.aws\\config"]
  # shared_credentials_files = ["%USERPROFILE%\\.aws\\credentials"]
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket  = "848615702835-devops-practice"
    key     = "devops/test-deploy/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
  required_version = ">= 0.13"
}