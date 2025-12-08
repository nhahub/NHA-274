resource "aws_ssm_parameter" "db_creds" {
  name      = "/prod/mongo/credentials"
  type      = "SecureString"
  overwrite = true
  value = jsonencode({
    MONGO_INITDB_ROOT_USERNAME = var.mongo_username
    MONGO_INITDB_ROOT_PASSWORD = var.mongo_password
    MONGO_INITDB_DATABASE      = var.mongo_database
  })
}

resource "aws_ssm_parameter" "back_creds" {
  name      = "/prod/back/credentials"
  type      = "SecureString"
  overwrite = true
  value = jsonencode({
    MONGO_URI         = "mongodb://${var.mongo_username}:${var.mongo_password}@db-svc:27017/${var.mongo_database}?authSource=admin"
    PAYPAL_CLIENT_ID  = var.paypal_client_id
    PAYPAL_APP_SECRET = var.paypal_app_secret
    JWT_SECRET        = var.jwt_secret
  })
}
