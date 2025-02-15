resource "vault_policy" "prometheus" {
  name = "prometheus"

  policy = <<EOT
path "${local.consul_mount_path}/creds/prometheus" {
  capabilities = ["read"]
}

path "secret/prometheus/*" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_cert_auth_backend_role" "prometheus" {
  backend = local.step_cert_auth_path

  name         = vault_policy.prometheus.name
  display_name = vault_policy.prometheus.name

  certificate = file("/usr/local/share/ca-certificates/smallstep-homelab-prod.crt")

  allowed_common_names = [
    "prometheus.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.58/32",
  ]

  token_policies = [
    "default",
    vault_policy.default_apps.name,
    vault_policy.prometheus.name,
  ]
}

resource "consul_acl_policy" "prometheus" {
  name  = vault_policy.prometheus.name
  rules = <<-RULE
    service_prefix "${vault_policy.prometheus.name}" {
      policy = "write"
    }

    # Prometheus needs to read metrics from consul servers
    # This also allows viewing config and logs
    # Which probably isn't 100% safe
    # We probably could do a HAProxy to only expose
    # the /metrics path.
    agent_prefix "hashi-consul-" {
      policy = "read"
    }
    RULE
}

resource "vault_consul_secret_backend_role" "prometheus" {
  name    = vault_policy.prometheus.name
  backend = local.consul_mount_path

  consul_policies = [
    consul_acl_policy.default_apps.name,
    consul_acl_policy.prometheus.name,
  ]

  node_identities = [
    for name in vault_cert_auth_backend_role.prometheus.allowed_common_names : "${split(".", "${name}")[0]}:hl-us-homelab1"
  ]
}
