resource "vault_policy" "haproxy-t2" {
  name = "haproxy-t2"

  policy = <<EOT
path "pki_step_x5c_haproxy_intermediate/issue/*" {
  capabilities = ["update"]
}
EOT
}

resource "vault_cert_auth_backend_role" "haproxy-t2" {
  backend = vault_auth_backend.auth_step_cert.path

  name         = vault_policy.haproxy-t2.name
  display_name = vault_policy.haproxy-t2.name

  certificate = file("/usr/local/share/ca-certificates/smallstep-homelab-prod.crt")

  allowed_common_names = [
    "haproxy-t2-1.us-homelab1.hl.rmb938.me",
    "haproxy-t2-2.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.49/32",
    "192.168.23.50/32",
  ]

  token_policies = [
    "default",
    vault_policy.default_apps.name,
    vault_policy.haproxy-t2.name,
  ]
}

resource "vault_consul_secret_backend_role" "haproxy-t2" {
  for_each = toset(vault_cert_auth_backend_role.haproxy-t2.allowed_common_names)

  name    = each.value
  backend = local.consul_mount_path

  consul_policies = [
    consul_acl_policy.default_apps.name,
  ]

  node_identities = ["${each.value}:hl-us-homelab1"]
}
