output "lb_public_ip" {
  description = "IP público do Load Balancer"
  value       = azurerm_public_ip.lb.ip_address
}