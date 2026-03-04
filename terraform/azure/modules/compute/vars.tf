variable "rg_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Região Azure"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet"
  type        = string
}

variable "vm_size" {
  description = "Tamanho da VM Azure"
  type        = string
}

variable "admin_username" {
  description = "Usuário administrador da VM"
  type        = string
}

variable "ssh_public_key" {
  description = "Chave SSH pública"
  type        = string
  sensitive   = true
}