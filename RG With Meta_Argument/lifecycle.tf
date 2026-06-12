
# ==========================================================
# Create an Azure Resource Group
# ==========================================================
resource "azurerm_resource_group" "rg" {

  # Resource Group Name
  name = "dev-rg"

  # Azure Region
  location = "East US"

  # ========================================================
  # Lifecycle Meta-Argument
  # Controls how Terraform creates, updates,
  # replaces, or destroys resources.
  # ========================================================
  lifecycle {

    # ------------------------------------------------------
    # 1. create_before_destroy
    # Creates the new resource first and deletes
    # the old one only after the new one is ready.
    # Prevents downtime.
    # ------------------------------------------------------
    create_before_destroy = true

    # ------------------------------------------------------
    # 2. prevent_destroy
    # Prevents accidental deletion of the resource.
    # Terraform will throw an error if someone
    # runs "terraform destroy".
    # ------------------------------------------------------
    prevent_destroy = false

    # ------------------------------------------------------
    # 3. ignore_changes
    # Ignore changes made outside Terraform.
    # Terraform won't try to revert them.
    # Useful when another team or Azure updates
    # certain properties automatically.
    # ------------------------------------------------------
    ignore_changes = [
      tags
    ]

    # ------------------------------------------------------
    # 4. replace_triggered_by
    # Recreate this resource whenever the specified
    # resource changes.
    # Useful when resources depend on each other.
    # ------------------------------------------------------
    replace_triggered_by = [
      azurerm_storage_account.storage
    ]
  }

  # Resource Tags
  tags = {
    Environment = "Development"
    Owner       = "Terraform"
  }
}

# ==========================================================
# Storage Account
# Used only to demonstrate replace_triggered_by
# ==========================================================
resource "azurerm_storage_account" "storage" {

  name                     = "devstorage123456"

  resource_group_name      = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"

  account_replication_type = "LRS"
}

# ==========================================================
# Summary
#
# create_before_destroy
# -> Create new resource first, then delete old one.
#
# prevent_destroy
# -> Protect resource from accidental deletion.
#
# ignore_changes
# -> Ignore selected property changes made outside Terraform.
#
# replace_triggered_by
# -> Force recreation when another resource changes.
# ==========================================================