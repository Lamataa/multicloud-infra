output "alb_dns" {
  description = "DNS do Load Balancer"
  value       = aws_lb.main.dns_name
}