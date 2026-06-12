resource "azurerm_linux_virtual_machine" "vm" {

  # VM Name
  name                = "linux-vm"

  # Resource Group
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # VM Size
  size = "Standard_B1s"

  # Linux Username
  admin_username = "azureuser"

  # Attach Network Interface
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  # SSH Public Key
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  # OS Disk
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Ubuntu Image
  source_image_reference {
    publisher = "Canonical"
    offer      = "0001-com-ubuntu-server-jammy"
    sku        = "22_04-lts"
    version    = "latest"
  }

  # ---------------------------------------------------
  # Connection Block
  # Terraform connects to the VM using SSH
  # ---------------------------------------------------
  connection {
    type        = "ssh"
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip_address
  }

  # ---------------------------------------------------
  # Copy a local file to the remote VM
  # ---------------------------------------------------
  provisioner "file" {

    # Local file on your machine
    source = "index.html"

    # Destination path inside the VM
    destination = "/home/azureuser/index.html"
  }
}