variable "location" {
  description = "Região Azure"
  type        = string
  default     = "West US 2"
}

variable "rg_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "InfraAZURE-rg"
}

variable "vnet_cidr" {
  description = "CIDR block da VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block da subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "vm_size" {
  type    = string
  default = "Standard_F2ads_v7"
}

variable "admin_username" {
  description = "Usuário administrador da VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "Chave SSH pública"
  type        = string
  sensitive   = true
}