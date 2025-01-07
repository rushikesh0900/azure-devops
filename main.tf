provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "myrgprod" {
    name = var.resource_group_name
    location = var.location
  
}

resource "azurerm_virtual_network" "myvnetprod" {
    name = var.vnet_name
    address_space = var.vnet_address_space
    resource_group_name = var.resource_group_name
    location = var.location
  
}

resource "azurerm_subnet" "mysubnetprod" {
  name = var.subnet_name
  resource_group_name = var.resource_group_name
  address_prefixes = [var.subnet_address_prefix]
  virtual_network_name = var.vnet_name
}

resource "azurerm_network_security_group" "mynsgprod" {
    name = var.nsg_name
    resource_group_name = var.resource_group_name
    location = var.location

    security_rule {
        name = "AllowRDP"
        priority = 100
        direction = "inbound"
        access = "Allow"
        protocol = "TCP"
        source_port_range = "*"
        destination_port_range = "3389"
        source_address_prefix = "*"
        destination_address_prefix = "*"

    }
}

resource "azurerm_subnet_network_security_group_association" "rgprodnsgsubnet" {
    subnet_id = azurerm_subnet.mysubnetprod.id
    network_security_group_id = azurerm_network_security_group.mynsgprod.id
  depends_on = [azurerm_network_security_group.mynsgprod ]
}

resource "azurerm_public_ip" "prodPIP" {
    name = var.public_ip_name
    resource_group_name = var.resource_group_name
    location = var.location
    allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "prod-nic" {
    name = var.nic_name
    location = var.location
    resource_group_name = var.resource_group_name
    ip_configuration {
      name = "MyIPConfiguration"
      subnet_id = azurerm_subnet.mysubnetprod.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.prodPIP
    }
}

resource "azurerm_windows_virtual_machine" "prodvm" {
    name = var.vm_name
    size = var.vm_size
    resource_group_name = var.resource_group_name
    location = var.location
    admin_username = var.admin_username
    admin_password = var.admin_password
    network_interface_ids = azurerm_network_interface.prod-nic
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standared_LRS"
    }
    source_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer = "WindowsServer"
      sku = "2019-Datacenter"
      version = "Latest"
    }
    depends_on = [ azurerm_subnet_network_security_group_association.rgprodnsgsubnet ]
}

output "public_ip" {
    value = azurerm_public_ip.prodPIP
}
  
