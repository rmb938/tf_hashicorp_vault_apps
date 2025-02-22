module "openstack-keystone" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-keystone"
  allowed_common_names = [
    "openstack-keystone-1.us-homelab1.hl.rmb938.me",
    "openstack-keystone-2.us-homelab1.hl.rmb938.me",
    "openstack-keystone-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.76/32",
    "192.168.23.77/32",
    "192.168.23.78/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-keystone" {
  capabilities = ["update"]
}
EOT
}
