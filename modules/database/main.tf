resource "aws_db_instance" "postgres" {
  identifier              = "main-db"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "17"
  instance_class          = var.db_instance_class
  db_name                 = "mydb"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = [var.db_sg_id]
  storage_encrypted       = true
  publicly_accessible     = false
  multi_az                = true
  backup_retention_period = var.backup_retention_period
  backup_window           = "04:00-06:00"
  maintenance_window      = "sun:07:00-sun:08:00"
  skip_final_snapshot     = true
}

resource "aws_db_snapshot" "manual_snapshot" {
  db_instance_identifier = aws_db_instance.postgres.identifier
  db_snapshot_identifier = "manual-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

data "aws_db_snapshot" "latest" {
  db_instance_identifier = aws_db_instance.postgres.identifier
  most_recent            = true
  depends_on             = [aws_db_snapshot.manual_snapshot]
}