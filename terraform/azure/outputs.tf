output "resource_group" {
  description = "Nome do Resource Group"
  value       = var.rg_name
}

output "lb_public_ip" {
  description = "IP público do Load Balancer"
  value       = module.compute.lb_public_ip
}

output "web_url" {
  description = "URL do servidor web"
  value       = "http://${module.compute.lb_public_ip}"
}