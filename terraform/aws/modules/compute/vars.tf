variable "rede_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets públicas"
  type        = list(string)
}

variable "rede_cidr" {
  description = "CIDR da VPC para regra de SSH"
  type        = string
}

variable "ami" {
  description = "ID da AMI"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}