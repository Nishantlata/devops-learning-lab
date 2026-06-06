# ==================================================
# TERRAFORM CONFIGURATION
# ==================================================
# required_version:
# Minimum Terraform version required to run this code.
#
# required_providers:
# Defines which provider Terraform should download
# and which version should be used.
# ==================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.70"
    }
  }
}

# ==================================================
# AZURE PROVIDER CONFIGURATION
# ==================================================
# Provider acts as a bridge between Terraform
# and Azure Resource Manager (ARM) APIs.
#
# features {}:
# Mandatory block for AzureRM provider.
# Used to configure provider-specific features.
# ==================================================

provider "azurerm" {
  features {}
}

# ==================================================
# LOCAL VALUES
# ==================================================
# Locals are used to avoid repeating values
# throughout the configuration.
#
# Here we map Terraform workspaces to different
# Resource Group names.
#
# Example:
# terraform workspace select dev
# -> rg-terraform-demo-dev
#
# terraform workspace select prod
# -> rg-terraform-demo-prod
# ==================================================

locals {
  resource_group_name = {
    default = "rg-terraform-demo"
    dev     = "rg-terraform-demo-dev"
    prod    = "rg-terraform-demo-prod"
    UAT     = "rg-terraform-demo-uat"
  }
}

# ==================================================
# AZURE RESOURCE GROUP
# ==================================================
# Creates an Azure Resource Group.
#
# Name:
# Dynamically selected based on current workspace.
#
# Location:
# Azure region where resources will be deployed.
#
# Tags:
# Used for resource organization, governance,
# cost management and filtering.
# ==================================================

resource "azurerm_resource_group" "rg1" {

  # Resource Group name based on workspace.
  name = local.resource_group_name[terraform.workspace]

  # Azure deployment region
  location = "East US"

  # Resource tags
  tags = {
    Environment = "${terraform.workspace}"
  }
}
