module "openstack-ovn-northd" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-ovn-northd"
  allowed_common_names = [
    "openstack-ovn-northd-1.us-homelab1.hl.rmb938.me",
    "openstack-ovn-northd-2.us-homelab1.hl.rmb938.me",
    "openstack-ovn-northd-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.97/32",
    "192.168.23.98/32",
    "192.168.23.99/32",
  ]
}
