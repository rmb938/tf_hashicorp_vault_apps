module "haproxy-t1" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "haproxy-t1"
  allowed_common_names = [
    "haproxy-t1-1.us-homelab1.hl.rmb938.me",
    "haproxy-t1-2.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.47/32",
    "192.168.23.48/32",
  ]
}
