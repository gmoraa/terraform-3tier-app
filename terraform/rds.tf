# RDS Instance Running Postgres
resource "aws_db_instance" "aws_db_instance_rdsdb" {
  allocated_storage         = 20
  max_allocated_storage     = 100
  publicly_accessible       = false
  engine                    = "postgres"
  engine_version            = "13.3"
  instance_class            = "db.t3.micro"
  db_name                   = "rdsdb"
  username                  = local.db_creds.username
  password                  = local.db_creds.password
  skip_final_snapshot       = false
  final_snapshot_identifier = "snapshot-${random_string.random.result}"
  vpc_security_group_ids    = [ aws_security_group.security_group_rds.id ]
  backup_window             = "09:30-10:00"
  backup_retention_period   = "30"
}

# Create Random Password
resource "random_password" "random_password" {
  length                    = 16
  special                   = true
  override_special          = "!#$%^&()_+"
  min_lower                 = 3
  min_upper                 = 3
  min_special               = 1
  min_numeric               = 1
}

# Snapshot Random Name
resource "random_string" "random" {
  length                    = 24
  special                   = false
  min_numeric               = 6
  min_lower                 = 3
  min_upper                 = 3
}

# Credentials Secret
resource "aws_secretsmanager_secret" "aws_secretsmanager_secret_rds" {
   name                    = "rds_db-${random_string.random.result}"
   recovery_window_in_days = 0
}

# Secret Version
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id                = aws_secretsmanager_secret.aws_secretsmanager_secret_rds.id
  secret_string            = <<EOF
   {
    "username": "postgres",
    "password": "${random_password.random_password.result}"
   }
EOF
}

data "aws_secretsmanager_secret" "aws_secretsmanager_secret_rds" {
  arn = aws_secretsmanager_secret.aws_secretsmanager_secret_rds.arn
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.aws_secretsmanager_secret_rds.arn
}

# Credentials Json Object
locals {
  db_creds = jsondecode(
  data.aws_secretsmanager_secret_version.creds.secret_string
   )
}