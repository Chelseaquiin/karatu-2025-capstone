terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  # IMPORTANT:
  # Run the bootstrap-backend folder first to create this bucket/table.
  # Then uncomment this backend block and run: terraform init -migrate-state
  # backend "s3" {
  #   bucket         = "bedrock-terraform-state-alt-soe-025-3792"
  #   key            = "prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-lock"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "karatu-2025-capstone"
      Environment = var.environment
      ManagedBy   = "Terraform"
      StudentId   = "alt-soe-025-3792"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}
