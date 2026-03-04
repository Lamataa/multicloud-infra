variable "rg_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Região Azure"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block da VNet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block da subnet"
  type        = string
}