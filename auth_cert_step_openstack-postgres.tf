resource "vault_policy" "openstack-postgres" {
  name = "openstack-postgres"

  policy = <<EOT
path "${local.consul_mount_path}/creds/openstack-postgres" {
  capabilities = ["read"]
}
EOT
}

resource "vault_cert_auth_backend_role" "openstack-postgres" {
  backend = local.step_cert_auth_path

  name         = vault_policy.openstack-postgres.name
  display_name = vault_policy.openstack-postgres.name

  certificate = file("/usr/local/share/ca-certificates/smallstep-homelab-prod.crt")

  allowed_common_names = [
    "openstack-postgres-1.us-homelab1.hl.rmb938.me",
    "openstack-postgres-2.us-homelab1.hl.rmb938.me",
    "openstack-postgres-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.70/32",
    "192.168.23.71/32",
    "192.168.23.72/32",
  ]

  token_policies = [
    "default",
    vault_policy.default_apps.name,
    vault_policy.openstack-postgres.name,
  ]
}

resource "consul_acl_policy" "openstack-postgres" {
  name  = vault_policy.openstack-postgres.name
  rules = <<-RULE
    service_prefix "${vault_policy.openstack-postgres.name}" {
      policy = "write"
    }
    RULE
}

resource "vault_consul_secret_backend_role" "hopenstack-postgres" {
  name    = vault_policy.openstack-postgres.name
  backend = local.consul_mount_path

  consul_policies = [
    consul_acl_policy.default_apps.name,
    consul_acl_policy.openstack-postgres.name,
  ]

  node_identities = [
    for name in vault_cert_auth_backend_role.openstack-postgres.allowed_common_names : "${split(".", "${name}")[0]}:hl-us-homelab1"
  ]
}
