terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
    consul = {
      source = "hashicorp/consul"
    }
  }
}

module "app" {
  source = "../app"

  consul_datacenter = var.consul_datacenter
  secret_mount_path = var.secret_mount_path
  consul_mount_path = var.consul_mount_path

  name                = var.name
  vault_policy_extra  = var.vault_policy_extra
  consul_policy_extra = var.consul_policy_extra
}

resource "vault_cert_auth_backend_role" "role" {
  depends_on = [module.app]

  backend = var.step_cert_auth_path

  name         = var.name
  display_name = var.name

  certificate = file("/usr/local/share/ca-certificates/smallstep-homelab-prod.crt")

  allowed_common_names = var.allowed_common_names
  token_bound_cidrs    = var.token_bound_cidrs

  token_policies = [
    "default",
    module.app.vault_policy_name
  ]
}

resource "vault_consul_secret_backend_role" "role" {
  depends_on = [module.app]

  backend = var.consul_mount_path

  name = var.name

  consul_policies = [
    module.app.consul_acl_policy_name
  ]

  node_identities = [
    for name in vault_cert_auth_backend_role.role.allowed_common_names : "${split(".", "${name}")[0]}:${var.consul_datacenter}"
  ]
}
