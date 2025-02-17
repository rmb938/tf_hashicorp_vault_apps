module "haproxy-t2" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "haproxy-t2"
  allowed_common_names = [
    "haproxy-t2-1.us-homelab1.hl.rmb938.me",
    "haproxy-t2-2.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.49/32",
    "192.168.23.50/32",
  ]

  vault_policy_extra = <<EOT
path "pki_step_x5c_haproxy_intermediate/issue/*" {
  capabilities = ["update"]
}
EOT
}
