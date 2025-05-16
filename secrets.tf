resource "aws_secretsmanager_secret" "app_key" {
  name = "${var.name}-app_key-${random_string.secrets_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "app_key" {
  secret_id     = aws_secretsmanager_secret.app_key.id
  secret_string = random_password.app_key.result
}

resource "random_password" "app_key" {
  length  = 32
  special = true

  lifecycle {
    ignore_changes = [
      length,
      special
    ]
  }
}

resource "random_password" "admin_credentials" {
  length = 16

  lifecycle {
    ignore_changes = [
      length
    ]
  }
}

resource "random_string" "secrets_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = false

  lifecycle {
    ignore_changes = [
      length,
      special,
      upper,
      numeric,
    ]
  }
}

resource "aws_secretsmanager_secret" "admin_credentials" {
  name = "${var.name}-admin_credentials-${random_string.secrets_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "admin_credentials" {
  secret_id = aws_secretsmanager_secret.admin_credentials.id
  secret_string = jsonencode({
    email    = var.admin_email
    password = random_password.admin_credentials.result
  })
}
