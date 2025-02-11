resource "vault_policy" "haproxy-t1" {
  name = "haproxy-t1"

  policy = <<EOT
path "${local.consul_mount_path}/creds/haproxy-t1" {
  capabilities = ["read"]
}
EOT
}

resource "vault_cert_auth_backend_role" "haproxy-t1" {
  backend = local.step_cert_auth_path

  name         = vault_policy.haproxy-t1.name
  display_name = vault_policy.haproxy-t1.name

  certificate = file("/usr/local/share/ca-certificates/smallstep-homelab-prod.crt")

  allowed_common_names = [
    "haproxy-t1-1.us-homelab1.hl.rmb938.me",
    "haproxy-t1-2.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.47/32",
    "192.168.23.48/32",
  ]

  token_policies = [
    "default",
    vault_policy.default_apps.name,
    vault_policy.haproxy-t1.name,
  ]
}

resource "consul_acl_policy" "haproxy-t1" {
  name  = vault_policy.haproxy-t1.name
  rules = <<-RULE
    service_prefix "${vault_policy.haproxy-t1.name}" {
      policy = "write"
    }
    RULE
}

resource "vault_consul_secret_backend_role" "haproxy-t1" {
  name    = vault_policy.haproxy-t1.name
  backend = local.consul_mount_path

  consul_policies = [
    consul_acl_policy.default_apps.name,
    consul_acl_policy.haproxy-t1.name,
  ]

  node_identities = [
    for name in vault_cert_auth_backend_role.haproxy-t1.allowed_common_names : "${split(".", "${name}")[0]}:hl-us-homelab1"
  ]
}
