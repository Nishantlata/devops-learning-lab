# Create multiple Azure Resource Groups using for_each
resource "azurerm_resource_group" "rg" {

  # Convert the collection into a Set and iterate over each value
  # toset() is list ko Set me convert karta hai.
  # for_each List par directly iterate nahi karta.ye sirf map aur set par iterate karta hai.
  for_each = toset(var.rg_name)

  # Resource Group name (dev, test, prd, uat)
  name = each.key

  # Azure region where all Resource Groups will be created
  location = var.location
}

# Variable containing Resource Group names
variable "rg_name" {

  # Set of strings (duplicates are automatically removed)
  type = set(string)

  # Resource Group names
  default = [
    "dev",
    "test",
    "prd",
    "uat"
  ]
}

# Azure region
variable "location" {

  # Location data type
  type = string

  # Default Azure region
  default = "eastus"
}
