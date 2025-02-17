variable "name" {
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

variable "vault_policy_extra" {
  type = string
}

variable "consul_policy_extra" {
  type = string
}

output "vault_policy_name" {
  value = vault_policy.policy.name
}

output "consul_acl_policy_name" {
  value = consul_acl_policy.policy.name
}
