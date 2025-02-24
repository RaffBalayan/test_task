module "networking" {
  source = "./modules/networking"

  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
}

module "ecs" {
  source = "./modules/ecs"

  private_subnet_ids = module.networking.private_subnet_ids
  ecs_sg_id          = module.networking.ecs_sg_id
  target_group_arn   = module.networking.target_group_arn
}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "prod/rds/credentials"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

module "database" {
  source = "./modules/database"

  db_subnet_group_name    = module.networking.rds_subnet_group_name
  db_sg_id                = module.networking.db_sg_id
  db_instance_class       = var.db_instance_class
  db_username             = var.db_username
  db_password             = jsondecode(aws_secretsmanager_secret_version.rds_credentials.secret_string)["password"]
  backup_retention_period = var.backup_retention_period
}