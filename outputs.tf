output "load_balancer_dns_name" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the application load balancer."
  value       = aws_lb.main.zone_id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group that manages the web tier."
  value       = aws_autoscaling_group.web.name
}

output "web_tier_security_group_id" {
  description = "Security group used by the web instances."
  value       = aws_security_group.web.id
}
