variable "name" {
  type = string
}

variable "step_cert_auth_path" {
  type = string
}

variable "secret_mount_path" {
  type = string
}

variable "consul_mount_path" {
  type = string
}

variable "consul_datacenter" {
  type = string
}

variable "allowed_common_names" {
  type = list(string)
}

variable "token_bound_cidrs" {
  type = list(string)
}

variable "vault_policy_extra" {
  type    = string
  default = ""
}

variable "consul_policy_extra" {
  type    = string
  default = ""
}
