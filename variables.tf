variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region for resources"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
}

variable "subnet_name" {
  description = "Name of the Subnet"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the Subnet"
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
}

variable "public_ip_name" {
  description = "Name of the Public IP"
}

variable "nic_name" {
  description = "Name of the Network Interface"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
}

variable "admin_username" {
  description = "Administrator username for the VM"
}

variable "admin_password" {
  description = "Administrator password for the VM"
  sensitive   = true
}
