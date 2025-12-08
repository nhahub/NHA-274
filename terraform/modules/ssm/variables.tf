variable "mongo_username" {
  type      = string
  sensitive = true
}

variable "mongo_password" {
  type      = string
  sensitive = true
}

variable "mongo_database" {
  type = string
}

variable "paypal_client_id" {
  type      = string
  sensitive = true
}

variable "paypal_app_secret" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}
