output "vpc_id" {
  description = "ID da VPC"
  value       = module.rede.vpc_id
}

output "alb_dns" {
  description = "DNS do Load Balancer"
  value       = module.compute.alb_dns
}

output "web_url" {
  description = "URL do servidor web"
  value       = "http://${module.compute.alb_dns}"
}