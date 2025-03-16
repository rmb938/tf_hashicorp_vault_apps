module "openstack-glance" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-glance"
  allowed_common_names = [
    "openstack-glance-1.us-homelab1.hl.rmb938.me",
    "openstack-glance-2.us-homelab1.hl.rmb938.me",
    "openstack-glance-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.79/32",
    "192.168.23.80/32",
    "192.168.23.81/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-glance" {
  capabilities = ["update"]
}
EOT
}
