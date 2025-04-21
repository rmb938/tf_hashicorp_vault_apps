module "openstack-placement" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-placement"
  allowed_common_names = [
    "openstack-placement-1.us-homelab1.hl.rmb938.me",
    "openstack-placement-2.us-homelab1.hl.rmb938.me",
    "openstack-placement-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.85/32",
    "192.168.23.86/32",
    "192.168.23.87/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-placement" {
  capabilities = ["update"]
}

path "${local.secret_mount_path}/openstack-keystone/service-users/placement" {
  capabilities = ["read"]
}
EOT
}
