###############################################################################
# Terraform Configuration
###############################################################################

terraform {

  # required_providers batata hai ki is project me kaunsa provider use hoga.
  # Jab hum "terraform init" chalate hain, Terraform HashiCorp Registry se
  # AzureRM provider download karta hai.

  required_providers {

    azurerm = {

      # Provider ka source (HashiCorp Registry)
      source = "hashicorp/azurerm"

      # AzureRM provider ka version.
      # Best Practice: Production me version ko pin karna chahiye.
      version = "4.77.0"
    }
  }
}

###############################################################################
# Azure Provider Configuration
###############################################################################

# Provider block Terraform ko batata hai ki Azure ke resources manage karne hain.
#
# Authentication Azure CLI, Service Principal, Managed Identity ya OIDC se ho
# sakti hai.
#
# Agar machine par pehle se "az login" hua hai to Terraform automatically
# Azure CLI credentials use kar lega.

provider "azurerm" {

  # features {} AzureRM provider ka mandatory block hai.
  # Future me Azure provider ki advanced settings isi block me configure hoti hain.

  features {}
}

###############################################################################
# Example 1 : Count Meta Argument
###############################################################################

resource "azurerm_resource_group" "rg" {

  # count Meta Argument hai.
  #
  # count = 5
  #
  # Matlab Terraform is resource ko 5 baar create karega.

  count = 5

  # count.index automatic variable hai.
  #
  # First Resource  -> count.index = 0
  # Second Resource -> count.index = 1
  # Third Resource  -> count.index = 2
  #
  # Final Names
  #
  # guru-rg-0
  # guru-rg-1
  # guru-rg-2
  # guru-rg-3
  # guru-rg-4

  name = "guru-rg-${count.index}"

  # Azure Region
  location = "eastus"
}

###############################################################################
# Example 2 : Count with Variables
###############################################################################

# Is example me count hardcoded nahi hai.
# count automatically variable ki length ke according calculate hoga.

resource "azurerm_resource_group" "rg" {

  # length() list me total kitne elements hain wo return karta hai.
  #
  # Agar list me 5 names hain to count automatically 5 ho jayega.
  #
  # Agar future me list me 10 names ho gaye
  # to automatically 10 Resource Groups create ho jayenge.

  count = length(var.rg_name)

  # count.index har iteration me list ka next element read karta hai.
  #
  # count.index = 0
  # var.rg_name[0]
  #
  # count.index = 1
  # var.rg_name[1]
  #
  # count.index = 2
  # var.rg_name[2]

  name = var.rg_name[count.index]

  # Azure Region variable se read hogi.

  location = var.location
}

###############################################################################
# Variables
###############################################################################

variable "rg_name" {

  # List of String Variable
  # Is variable me multiple Resource Group names store honge.

  type = list(string)

  # NOTE:
  # Strings ko hamesha double quotes (" ") me likhna chahiye.
  #
  # Correct Example:
  #
  # default = [
  #   "rg1",
  #   "rg2",
  #   "rg3",
  #   "rg4",
  #   "rg5"
  # ]

  default = [rg1, rg2, rg3, rg4, rg5]
}

###############################################################################
# Azure Location Variable
###############################################################################

variable "location" {

  # String Variable

  type = string

  # Default Azure Region

  default = "eastus"
}