variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "rede_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_a" {
  description = "CIDR subnet us-east-1a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_b" {
  description = "CIDR subnet us-east-1b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ami" {
  description = "ID da AMI — Amazon Linux 2023 us-east-1"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}