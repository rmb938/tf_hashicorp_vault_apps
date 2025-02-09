resource "vault_policy" "haproxy-t2" {
  name = "haproxy-t2"

  policy = <<EOT
path "pki_step_x5c_haproxy_intermediate/issue/*" {
  capabilities = ["update"]
}

path "consul/creds/haproxy-t2" {
  capabilities = ["read"]
}
EOT
}

resource "vault_cert_auth_backend_role" "haproxy-t2" {
  backend = local.step_cert_auth_path

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

resource "consul_acl_policy" "haproxy-t2" {
  name  = vault_policy.haproxy-t2.name
  rules = <<-RULE
    # Allow reading all services
    service "${vault_policy.haproxy-t2.name}" {
      policy = "write"
    }
    RULE
}

resource "vault_consul_secret_backend_role" "haproxy-t2" {
  name    = vault_policy.haproxy-t2.name
  backend = local.consul_mount_path

  consul_policies = [
    consul_acl_policy.default_apps.name,
    consul_acl_policy.haproxy-t2.name,
  ]

  node_identities = [
    for name in vault_cert_auth_backend_role.haproxy-t2.allowed_common_names : name
  ]
}
