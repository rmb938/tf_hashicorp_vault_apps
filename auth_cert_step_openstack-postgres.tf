module "openstack-postgres" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-postgres"
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
}
