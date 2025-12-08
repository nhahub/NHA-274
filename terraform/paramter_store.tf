resource "aws_ssm_parameter" "db_creds" {
  name      = "/prod/mongo/credentials"
  type      = "SecureString"
  overwrite = true
  value     = jsonencode({
    MONGO_INITDB_ROOT_USERNAME   = local.secrets.MONGO_INITDB_ROOT_USERNAME
    MONGO_INITDB_ROOT_PASSWORD   = local.secrets.MONGO_INITDB_ROOT_PASSWORD
    MONGO_INITDB_DATABASE        = local.secrets.MONGO_INITDB_DATABASE
  })
}

resource "aws_ssm_parameter" "back_creds" {
  name      = "/prod/back/credentials"
  type      = "SecureString"
  overwrite = true
  value     = jsonencode({
    MONGO_URI    = "mongodb://${local.secrets.MONGO_INITDB_ROOT_USERNAME}:${local.secrets.MONGO_INITDB_ROOT_PASSWORD}@db-svc:27017/${local.secrets.MONGO_INITDB_DATABASE}?authSource=admin"
    PAYPAL_CLIENT_ID      = local.secrets.PAYPAL_CLIENT_ID
    PAYPAL_APP_SECRET      = local.secrets.PAYPAL_APP_SECRET
    JWT_SECRET  = local.secrets.JWT_SECRET
  })
}