module "openstack-nova-controller" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-nova-controller"
  allowed_common_names = [
    "openstack-nova-1.us-homelab1.hl.rmb938.me",
    "openstack-nova-2.us-homelab1.hl.rmb938.me",
    "openstack-nova-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.88/32",
    "192.168.23.89/32",
    "192.168.23.90/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-nova" {
  capabilities = ["update"]
}
path "pki_openstack_rabbitmq_intermediate/issue/user-nova-controller" {
  capabilities = ["update"]
}

path "${local.secret_mount_path}/openstack-keystone/service-users/nova-controller" {
  capabilities = ["read"]
}
EOT
}
