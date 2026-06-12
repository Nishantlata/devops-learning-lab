# ==========================================================
# Terraform Configuration
# Specify the AzureRM provider and its version
# ==========================================================
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.77.0"
    }
  }
}

# ==========================================================
# Azure Provider Configuration
# ==========================================================
provider "azurerm" {

  # Prevents Terraform from auto-registering Resource Providers.
  # Use this if your account doesn't have permission to register them.
  resource_provider_registrations = "none"

  # Required provider features block
  features {}

  # Azure Subscription where resources will be created
  subscription_id = "047e5876-fb5f-4978-be6b-c4e8825f0313"
}

# ==========================================================
# Create Multiple Resource Groups using for_each + Map(Object)
# ==========================================================
resource "azurerm_resource_group" "rg0" {

  # Loop through each item in the map
  for_each = var.rg_names

  # each.value represents the object of the current map item
  name     = each.value.name
  location = each.value.location
}

# ==========================================================
# Variable: Map of Resource Groups
#
# Key (rg1, rg2) -> Used only for iteration
# Value          -> Object containing name & location
# ==========================================================
variable "rg_names" {

  # Map where each value is an object
  type = map(object({
    name     = string
    location = string
  }))

  # Default Resource Groups
  default = {

    # Map Key
    rg1 = {

      # Resource Group Name
      name = "dev-rg1"

      # Azure Region
      location = "eastus"
    }

    # Another Map Key
    rg2 = {

      # Resource Group Name
      name = "prod-rg2"

      # Azure Region
      location = "westus"
    }
  }
}

# ==========================================================
# What happens after terraform apply?
#
# rg1  --> dev-rg1   --> eastus
# rg2  --> prod-rg2  --> westus
#
# Terraform creates 2 Resource Groups automatically.
# ==========================================================



