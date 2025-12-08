variable "cluster_name" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "node_group_role_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "node_group_instance_type" {
  type    = string
  default = "c7i-flex.large"
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "min_size" {
  type    = number
  default = 1
}

variable "lbc_role_arn" {
  type = string
}

variable "eso_role_arn" {
  type = string
}

variable "edns_role_arn" {
  type = string
}

variable "ebs_role_arn" {
  type = string
}
