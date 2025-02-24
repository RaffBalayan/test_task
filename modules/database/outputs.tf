output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "latest_snapshot_arn" {
  value = data.aws_db_snapshot.latest.db_snapshot_arn
}