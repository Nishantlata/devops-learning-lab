resource "azurerm_resource_group" "rg" {
  name     = "rg-localexec-demo"
  location = "Central India"

  # Run a simple echo command after Resource Group creation
  provisioner "local-exec" {
    command = "echo Resource Group Created Successfully"
  }

  # Run a PowerShell command on the local machine
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "Write-Host 'Resource Group Created Successfully'"
  }

  # Execute Azure CLI command on the local machine
  provisioner "local-exec" {
    command = "az group show --name rg-localexec-demo"
  }
}