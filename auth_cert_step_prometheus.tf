module "prometheus" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "prometheus"
  allowed_common_names = [
    "prometheus.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.58/32",
  ]

  consul_policy_extra = <<EOT
# Prometheus needs to read metrics from consul servers
# This also allows viewing config and logs
# Which probably isn't 100% safe
# We probably could do a HAProxy to only expose
# the /metrics path.
agent_prefix "hashi-consul-" {
  policy = "read"
}
EOT
}
