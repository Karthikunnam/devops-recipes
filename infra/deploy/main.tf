terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.0"
    }
  }

  # Backend configuration should be defined only during initialization
  backend "s3" {
    bucket               = "my-project-recipe"
    key                  = "tf-state-deploy"
    workspace_key_prefix = "tf-state-deploy-env"
    region               = "us-east-1"
    encrypt              = true
    dynamodb_table       = "recipe-table"
  }
}

# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = terraform.workspace
      project     = var.project
      contact     = var.contact
      ManageBy    = "Terraform/Deploy"
    }
  }
}

# Locals Block - Define custom values
locals {
  prefix = "${var.prefix}-${terraform.workspace}"
}

# AWS Region Data Source
data "aws_region" "current" {}

