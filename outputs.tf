output "alb_dns_name" {
  description = "Application Load Balancer DNS"
  value       = module.networking.alb_dns_name
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "db_snapshot_arn" {
  description = "Latest DB snapshot ARN"
  value       = module.database.latest_snapshot_arn
}