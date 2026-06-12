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
  # Terraform uses these details to SSH into the VM.
  # Without this block, remote-exec cannot connect.
  # ---------------------------------------------------
  connection {

    # Connection type (Linux = ssh, Windows = winrm)
    type = "ssh"

    # Username used to login
    user = "azureuser"

    # Private key matching the public key in the VM
    private_key = file("~/.ssh/id_rsa")

    # Public IP of the VM
    host = self.public_ip_address
  }

  # ---------------------------------------------------
  # Run commands inside the VM after creation
  # ---------------------------------------------------
  provisioner "remote-exec" {

    # Commands execute one by one
    inline = [

      # Print message
      "echo 'Terraform connected successfully!'",

      # Update packages
      "sudo apt update",

      # Install Nginx
      "sudo apt install -y nginx",

      # Enable Nginx service
      "sudo systemctl enable nginx",

      # Start Nginx
      "sudo systemctl start nginx"
    ]
  }
}